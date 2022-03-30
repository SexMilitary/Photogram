//
//  SearchViewController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let photoService = SearchPhotoServices()
    
    private var viewModel = SearchPhotos()
    
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func search(page: Int, query: String) {
        let request = SearchPhotoRequest(page: page, query: query)
        photoService.searchPhotos(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.viewModel = data
                let collection = self.view as? SearchCollectionView
                collection?.findedPhotos = data
                collection?.reloadData()
            case .failure(let error):
                UIAlertController.alert(title: "Warning", msg: error.localizedDescription, target: self)
            }
        }
    }

}

extension SearchViewController: SearchCollectionViewDelegate {
    func searchPhotos(page: Int, query: String) {
        search(page: page, query: query)
    }
}
