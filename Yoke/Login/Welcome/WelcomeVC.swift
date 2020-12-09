//
//  WelcomeVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 3/7/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "introBackground")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
        
        view.addSubview(logoView)
        logoView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 100)
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logoWhite")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
//        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    

}
