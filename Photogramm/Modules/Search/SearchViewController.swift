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
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        
        let collectionView = SearchCollectionView()
        collectionView.searchDelegate = self
        view = collectionView
        navigationItem.titleView = collectionView.searchBar
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func search(query: String) {
        let request = SearchPhotoRequest(page: initialPage, query: query)
        photoService.searchPhotos(request: request) { [weak self] result in
            guard let self = self else { return }
            self.initialPage += 1
            
            switch result {
            case .success(let data):
                let collection = self.view as? SearchCollectionView
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
