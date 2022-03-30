//
//  UIViewContriller+Extension.swift
//  Photogramm
//
//  Created by Максим Чикинов on 27.03.2022.
//

import UIKit

extension UIViewController {
    
    func createNavController(title: String, image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: self)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        self.navigationItem.title = title
        
        return navController
    }
    
}
