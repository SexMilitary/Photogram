//
//  TabBar.swift
//  Photogramm
//
//  Created by Максим Чикинов on 27.03.2022.
//

import UIKit

class TabBar: UITabBarController {
    
    private let mainViewController = MainViewController()
    private let searchVieController = SearchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVCs()
    }
    
    func setupVCs() {
        viewControllers = [
            mainViewController.createNavController(title: "Fooder",
                                                   image: UIImage(systemName: "house") ?? UIImage()),
            searchVieController.createNavController(title: "Search",
                                                    image: UIImage(systemName: "magnifyingglass") ?? UIImage())
        ]
    }
    
}
