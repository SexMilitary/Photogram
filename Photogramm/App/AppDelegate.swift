//
//  AppDelegate.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationMenuBaseController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

