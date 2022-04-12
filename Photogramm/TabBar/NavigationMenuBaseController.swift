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
        
        delegate = self
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

extension NavigationMenuBaseController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
}

class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.2
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration,
                           delay: 0,
                           options: .curveEaseOut) {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            } completion: { success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            }
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
