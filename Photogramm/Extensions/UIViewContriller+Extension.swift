//
//  UIViewContriller+Extension.swift
//  Photogramm
//
//  Created by Максим Чикинов on 27.03.2022.
//

import UIKit

extension UIViewController {
    func createNavController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self)
        return navController
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
