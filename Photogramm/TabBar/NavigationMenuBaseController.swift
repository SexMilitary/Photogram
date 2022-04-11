//
//  NavigationMenuBaseController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 11.04.2022.
//

import UIKit

class NavigationMenuBaseController: UITabBarController {
    
    var customTabBar: TabNavigationMenu!
    var tabBarHeight: CGFloat = 67.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTabBar()
    }
    
    private func loadTabBar() {
        let tabItems: [TabItem] = TabItem.allCases
        
        setupCustomTabMenu(tabItems) { [weak self] (controllers) in
            guard let self = self else { return }
            self.viewControllers = controllers
        }
        
        selectedIndex = 0
    }
    
    private func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        tabBar.isHidden = true

        let frame = tabBar.frame
        var controllers = [UIViewController]()
        
        customTabBar = TabNavigationMenu(menuItems: menuItems, frame: frame)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.clipsToBounds = true
        customTabBar.itemTapped = changeTab
        
        view.addSubview(customTabBar)
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor, constant: 20),
            customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor, constant: -20),
            customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            customTabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
        
        for i in 0 ..< menuItems.count {
            controllers.append(menuItems[i].navigationController)
        }
        
        completion(controllers)
    }
    
    private func changeTab(tab: Int) {
        selectedIndex = tab
    }
    
}
