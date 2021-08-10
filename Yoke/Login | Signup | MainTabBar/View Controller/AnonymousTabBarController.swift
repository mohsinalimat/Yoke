//
//  AnonymousTabBarController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 7/29/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class AnonymousTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.isTranslucent = false
        view.backgroundColor = UIColor.orangeColor()
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginVC()
                let navController = UINavigationController(rootViewController: loginController)
                self.navigationController?.present(navController, animated: true)
            }
            return
        }
        setupViewControllers()
    }
    
    func setupViewControllers() {
        let searchNavController = templateNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!,rootViewController: SearchViewController())
        searchNavController.title = "Search"
        
        let eventsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "event_unselected"), selectedImage: #imageLiteral(resourceName: "event_selected"), rootViewController: EventsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        eventsNavController.title = "Events"
                
        let createAccountNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: CreateAccountViewController())
        createAccountNavController.title = "Create Account"
        tabBar.tintColor = .white
    
        self.viewControllers = [searchNavController, eventsNavController, createAccountNavController]
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
