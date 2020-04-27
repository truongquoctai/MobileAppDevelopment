//
//  AppDelegate.swift
//  Management Covid
//
//  Created by Mai Tài on 3/27/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigation = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        viewControllerStartApp()
        return true
    }

    func viewControllerStartApp(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let viewcontroller = SplashVC.init(nibName: String(describing: SplashVC.self), bundle: nil)
//        let vc = CreateAvatarVC(nibName: String(describing: CreateAvatarVC.self), bundle: nil)
        navigation = UINavigationController.init(rootViewController: viewcontroller)
        navigation.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
    }
}

