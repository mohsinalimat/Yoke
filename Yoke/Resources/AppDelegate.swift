//
//  AppDelegate.swift
//  Yoke
//
//  Created by LAURA JELENICH on 7/6/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        IQKeyboardManager.shared.enable = true
        STPPaymentConfiguration.shared().publishableKey = "pk_test_pX3V6XXnlsluthlhaKXHrW5U00WHz0znIt"
        
//        window = UIWindow()
//        window?.rootViewController = MainTabBarController()

        UINavigationBar.appearance().barTintColor = UIColor.orangeColor()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.orangeColor()
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        UITabBar.appearance().tintColor = UIColor.white
        
        return true
    }


}
