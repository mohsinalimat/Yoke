//
//  MainTabBarVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAlerts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("mainTabBar")
        self.delegate = self
        tabBar.isTranslucent = false
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginVC()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            
            return
        }
        setupViewControllers()
    }
    
    func setupAlerts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child(Constants.Invoices).child(uid).queryOrderedByValue().queryEqual(toValue: 1)
        .observe(DataEventType.value, with: { (snapshot) in
            let count = snapshot.childrenCount
            if count > 0 {
              self.tabBar.items![1].badgeValue = "\(Int(count))"
              self.tabBar.items![1].badgeColor = UIColor.white
              self.tabBar.items![1].setBadgeTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.mainColor(), NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 10)!
                ], for: .normal)
            }
        })
    }
    
    func setupViewControllers() {
        
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeVC())
        homeNavController.title = "Home"
        
        let messageNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "message_unselected"), selectedImage: #imageLiteral(resourceName: "message_selected"), rootViewController: MessageVC())
        messageNavController.title = "Messages"
        
        let searchNavController = templateNavController(unselectedImage: UIImage(named: "search_unselected")!, selectedImage: UIImage(named: "search_selected")!,rootViewController: SearchVC())
        searchNavController.title = "Search"
        
        let eventsNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "event_unselected"), selectedImage: #imageLiteral(resourceName: "event_selected"), rootViewController: EventsVC(collectionViewLayout: UICollectionViewFlowLayout()))
        eventsNavController.title = "Events"
                
        let paymentController = self.templateNavController(unselectedImage: UIImage(named: "payment_unselected")!, selectedImage: UIImage(named: "payment_selected")!, rootViewController: PaymentsVC(collectionViewLayout: UICollectionViewFlowLayout()))
        paymentController.title = "Payments"
        
        
        tabBar.tintColor = .white
        
        self.viewControllers = [homeNavController, messageNavController, searchNavController, eventsNavController, paymentController]
        //        let uid = FIRAuth.auth()?.currentUser?.uid
        //        FIRDatabase.userIsChef(userKey: uid!) { (isChef) in
        //            if isChef == true {
        //                self.viewControllers = [homeNavController, messageNavController, searchNavController, gigsNavController, calendarNavController]
        //            } else {
        //                self.viewControllers = [homeNavController, messageNavController, searchNavController, eventsNavController]
        //            }
        //        }
        
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
