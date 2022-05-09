//
//  PageViewController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 09.05.2022.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    private var controllers: [UIViewController]
    
    init(controllers: [UIViewController]) {
        self.controllers = controllers
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        dataSource = self
        delegate = self
        
        setViewControllers([controllers.first!],
                           direction: .forward,
                           animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    /// Before
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else { return nil }
        return controllers[index - 1]
    }
    
    /// After
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 else { return nil }
        return controllers[index + 1]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
}
