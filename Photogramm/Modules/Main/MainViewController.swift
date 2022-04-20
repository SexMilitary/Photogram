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
        
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        
        loadPhotos(page: 1, perPage: photosPageAmount)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Latest photos"
        view = PhotosCollectionView()
        view.backgroundColor = .background
        
        setupNavigationController()
        setRightBarButton()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 18)!]
    }
    
    private func setRightBarButton() {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "FilterIcon")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 25).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.addTarget(self, action: #selector(navBtnAction), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = item1
    }
    
    @objc
    private func navBtnAction() {
        
    }
    
    private func loadPhotos(page: Int, perPage: Int) {
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

