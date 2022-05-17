//
//  SearchViewController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let photoService = SearchPhotoServices()
    
    private var initialPage = 0
    
    private var pagesControllers = [SearchCollectionViewController]()
    
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
    
    private func setupFilterView() {
        view.addSubview(filterView)
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func addMockScreensPageViewController() {
        let collectionViewController = SearchCollectionViewController()
        collectionViewController.number = 0
        
        let collectionViewController2 = SearchCollectionViewController()
        collectionViewController2.number = 1
        
        let collectionViewController3 = SearchCollectionViewController()
        collectionViewController3.number = 2
        
        let collectionViewController4 = SearchCollectionViewController()
        collectionViewController4.number = 3
        
        let collectionViewController5 = SearchCollectionViewController()
        collectionViewController5.number = 4
        
        pagesControllers.append(contentsOf: [collectionViewController, collectionViewController2, collectionViewController3, collectionViewController4, collectionViewController5])
        
        pagesControllers.forEach { vc in
            vc.searchDelegate = self
        }
    }
    
    private func setupNavigationController() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.titleView = searchBar
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance;
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.backgroundColor = .white
        }
    }
    
    func search(query: String) {
        let request = SearchPhotoRequest(page: initialPage, query: query)
        photoService.searchPhotos(request: request) { [weak self] result in
            guard let self = self else { return }
            self.initialPage += 1
            
            switch result {
            case .success(let data):
                let pageViewController = self.children[0] as? PageViewController
                let collection = pageViewController?.viewControllers?[0] as? SearchCollectionViewController
                if collection?.findedPhotos == nil || (collection?.findedPhotos.isEmpty ?? false) {
                    collection?.findedPhotos = data
                } else {
                    collection?.findedPhotos.results.append(contentsOf: data.results)
                }
            case .failure(let error):
                UIAlertController.alert(title: "Warning", msg: error.localizedDescription, target: self)
            }
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
    }
}

extension SearchViewController: PageViewControllerProtocol {
    func didTransitionToController(of number: Int) {
        filterView.select(number)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showingViewController?.findedPhotos.clear()
        search(query: searchBarText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showingViewController?.findedPhotos.clear()
        showingViewController?.reloadCollection()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
