//
//  TabItem.swift
//  Photogramm
//
//  Created by Максим Чикинов on 11.04.2022.
//

import UIKit

enum TabItem: String, CaseIterable {
    
    case main = "main"
    case search = "search"
    case profile = "profile"
    case settings = "settings"
    
    var navigationController: UINavigationController {
        switch self {
        case .main:
            return MainViewController().createNavController()
        case .search:
            return SearchViewController().createNavController()
        case .profile:
            return MainViewController().createNavController()
        case .settings:
            return SearchViewController().createNavController()
        }
    }
    
    var icon: UIImage {
        switch self {
        case .main:
            return UIImage(systemName: "house")!
        case .search:
            return UIImage(systemName: "magnifyingglass")!
        case .profile:
            return UIImage(systemName: "person")!
        case .settings:
            return UIImage(systemName: "slider.vertical.3")!
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
    
}
