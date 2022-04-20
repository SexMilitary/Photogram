//
//  MainViewController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import UIKit

final class MainViewController: UIViewController {
    
    private let photoService = PhotoServices()
    
    private var viewModel = Photos()
    
    private let photosPageAmount = 30
    
    override func loadView() {
        super.loadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        
        loadPhotos(page: 1, perPage: photosPageAmount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Latest photos"
        view = PhotosCollectionView()
        view.backgroundColor = .background
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        checkConnection()
    }
    
    fileprivate func loadPhotos(page: Int, perPage: Int) {
        checkConnection()
        
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
    
    @objc
    private func showOfflineDeviceUI(notification: Notification) {
        showConnectionAlert()
    }
    
    private func showConnectionAlert() {
        DispatchQueue.main.async {
            if NetworkMonitor.shared.isConnected {
                print("Connected")
            } else {
                print("Not connected")
                self.showAlert("Внимание", message: "Интренет соединение не доступно. Проверьте доступ к интернету.",
                          showCancel: false,
                          cancelTitle: "",
                          okTitle: "Ok",
                          present: true) { [weak self] in
                    guard let self = self else { return }
                    self.loadPhotos(page: 1, perPage: self.photosPageAmount)
                }
            }
        }
    }
    
    private func checkConnection() {
        if !NetworkMonitor.shared.isConnected {
            showConnectionAlert()
        }
    }

}

