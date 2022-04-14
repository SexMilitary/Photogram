//
//  MainViewController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let photoService = PhotoServices()
    
    private var viewModel = PhotoResponce()
    
    private let photosPageAmount = 30
    
    override func loadView() {
        super.loadView()
        
        loadPhotos(page: 1, perPage: photosPageAmount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Latest photos"
        view = PhotosCollectionView()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    fileprivate func loadPhotos(page: Int, perPage: Int) {
        let request = PhotoRequest(page: page, perPage: perPage, orderBy: "latest")
        photoService.getPhotos(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.viewModel = data
                let collection = self.view as? PhotosCollectionView
                collection?.photos = data
                collection?.reloadData()
            case .failure(let error):
                UIAlertController.alert(title: "Warning", msg: error.localizedDescription, target: self)
            }
        }
    }

}

