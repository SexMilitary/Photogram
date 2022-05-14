//
//  PageViewController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 09.05.2022.
//

import UIKit

protocol PageViewControllerProtocol: AnyObject {
    func didTransitionToController(of number: Int)
}

final class PageViewController: UIPageViewController {
    
    weak var delegateAction: PageViewControllerProtocol?
    
    private var controllers: [UIViewController]
    private var currentNumber: Int
    
    init(controllers: [UIViewController], currentNumber: Int) {
        self.controllers = controllers
        self.currentNumber = currentNumber
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        dataSource = self
        delegate = self
        
        setViewControllers([controllers[0]],
                           direction: .forward,
                           animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    func selectControllerOf(number: Int) {
        let direction: UIPageViewController.NavigationDirection = number > currentNumber ? .forward : .reverse
        currentNumber = number
        setViewControllers([controllers[number]], direction: direction, animated: true)
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    /// Previos Page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else { return nil }
        return controllers[index - 1]
    }
    /// Next Page
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else { return nil }
        return controllers[index + 1]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    /// Definition current page number
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let vc = pendingViewControllers.first as? SearchCollectionViewController {
            currentNumber = vc.number
        }
    }
    
    /// Send didTransaction to VC message
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        guard completed else { return }
        delegateAction?.didTransitionToController(of: currentNumber)
    }
}
