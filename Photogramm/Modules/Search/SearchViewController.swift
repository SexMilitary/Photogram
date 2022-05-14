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
        view.frame = .init(x: 0,
                           y: self.view.safeAreaInsets.top + 105,
                           width: UIScreen.main.bounds.width,
                           height: 50)
        view.set(cells: SearchFilters())
        
        return view
    }()
    
    private lazy var pageViewController: PageViewController = {
        let pageViewController = PageViewController(controllers: pagesControllers, currentNumber: 0)
        pageViewController.delegateAction = self
        
        navigationItem.titleView = pagesControllers.first?.searchBar
        
        return pageViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        
        addMockScreensPageViewController()
        add(pageViewController)
        
        view.addSubview(filterView)
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
    func searchPhotos(query: String) {
        search(query: query)
    }
    func loadMore(query: String) {
        search(query: query)
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
