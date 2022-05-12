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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        addPageViewController()
        addSegmenter()
    }
    
    private func addPageViewController() {
        let collectionView = SearchCollectionViewController()
        collectionView.searchDelegate = self
        
        let pageViewController = PageViewController(controllers: [collectionView])
        add(pageViewController)
        
        navigationItem.titleView = collectionView.searchBar
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
    
    private func addSegmenter() {
        if let barFrame = navigationController?.navigationBar.frame {
            let view = FilterCollectionView()
            view.actionsDelegate = self
            view.backgroundColor = .tabBarBackground
            view.frame = .init(x: 0,
                               y: self.view.safeAreaInsets.top + 105,
                               width: barFrame.width,
                               height: 50)
            view.set(cells: SearchFilters())
            self.view.addSubview(view)
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
        print(model.title)
    }
}
