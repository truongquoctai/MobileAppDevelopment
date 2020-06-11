//
//  AppDelegate.swift
//  Management Covid
//
//  Created by Mai Tài on 3/27/20.
//  Copyright © 2020 Mai Tài. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigation = UINavigationController()
    var allowNotification = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        viewControllerStartApp()
        checkNotificationAccept()
        return true
    }

    func viewControllerStartApp(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let viewcontroller = SplashVC.init(nibName: String(describing: SplashVC.self), bundle: nil)
        navigation = UINavigationController.init(rootViewController: viewcontroller)
        navigation.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        
    }
    
    func checkNotificationAccept(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("checkNotificationAccept:Yes")
            } else {
                self.allowNotification = false
                print("checkNotificationAccept: No")
            }
        }
    }
    
}

