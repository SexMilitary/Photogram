//
//  SearchViewController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let photoService = SearchPhotoServices()
    
    private var pagesControllers = [SearchViewControllerModel]()
    
    private lazy var filterView: FilterCollectionView = {
        let view = FilterCollectionView()
        view.actionsDelegate = self
        view.backgroundColor = .tabBarBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.set(cells: SearchFilters())
        
        return view
    }()
    
    private lazy var pageViewController: PageViewController = {
        let pageViewController = PageViewController(controllers: pagesControllers, currentNumber: 0)
        pageViewController.delegateAction = self
        
        return pageViewController
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.searchBarStyle = .minimal
        bar.sizeToFit()
        bar.isTranslucent = false
        bar.backgroundImage = UIImage()
        bar.delegate = self
        bar.searchTextField.delegate = self
        bar.searchTextField.returnKeyType = .done
        
        return bar
    }()
    
    private var searchBarText: String {
        searchBar.text ?? ""
    }
    
    private var showingViewController: SearchCollectionViewController? {
        pageViewController.viewControllers?[0] as? SearchCollectionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMockScreensPageViewController()
        
        setupNavigationController()
        add(pageViewController)
        setupFilterView()
    }
}

// MARK: - Setup Views
private extension SearchViewController {
    func addMockScreensPageViewController() {
        for i in 0...5 {
            let page = SearchViewControllerModel(viewController: SearchCollectionViewController(number: i), number: i)
            pagesControllers.append(page)
        }
        
        pagesControllers.forEach { page in
            if let searchController = page.viewController as? SearchCollectionViewController {
                searchController.searchDelegate = self
            }
        }
    }
    
    func setupNavigationController() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.titleView = searchBar
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.backgroundColor = .white
        }
    }
    
    func setupFilterView() {
        view.addSubview(filterView)
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

private extension SearchViewController {
    func search(query: String) {
        let currentNumber = pageViewController.currentNumber
        let request = SearchPhotoRequest(page: pagesControllers[currentNumber].initialPage, query: query)
        photoService.searchPhotos(request: request) { [weak self] result in
            guard let self = self else { return }
            self.pagesControllers[currentNumber].initialPage += 1
            self.pagesControllers[self.pageViewController.currentNumber].lastSearchText = query
            
            switch result {
            case .success(let data):
                let collectionVC = self.pageViewController.viewControllers?.first as? SearchCollectionViewController
                if collectionVC?.findedPhotos == nil || (collectionVC?.findedPhotos.isEmpty ?? false) {
                    collectionVC?.findedPhotos = data
                } else {
                    collectionVC?.findedPhotos.results.append(contentsOf: data.results)
                }
            case .failure(let error):
                UIAlertController.alert(title: "Warning", msg: error.localizedDescription, target: self)
            }
        }
    }
    
    func searchByBarText() {
        let lastSearchText = pagesControllers[pageViewController.currentNumber].lastSearchText
        
        guard let searchString = (navigationItem.titleView as? UISearchBar)?.text,
              !searchString.isEmpty && searchString != lastSearchText
        else { return }
        
        search(query: searchString)
    }
    
    func clearAllPages() {
        pagesControllers.forEach { page in
            guard let searchController = page.viewController as? SearchCollectionViewController else { return }
            searchController.findedPhotos.clear()
            searchController.reloadCollection()
        }
    }
}

extension SearchViewController: SearchCollectionViewDelegate {
    var tabBarHeight: CGFloat {
        tabBarController?.tabBar.intrinsicContentSize.height ?? 0
    }
    func searchPhotos() {
        search(query: searchBarText)
    }
    func loadMore() {
        search(query: searchBarText)
    }
}

extension SearchViewController: FilterCollectionViewDelegate {
    func didSelectItem(model: SearchFilter) {
        pageViewController.selectControllerOf(number: model.type.rawValue)
        searchByBarText()
    }
}

extension SearchViewController: PageViewControllerProtocol {
    func didTransitionToController(of number: Int) {
        filterView.select(number)
        searchByBarText()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            clearAllPages()
            return
        }
        
        showingViewController?.findedPhotos.clear()
        search(query: searchBarText)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
