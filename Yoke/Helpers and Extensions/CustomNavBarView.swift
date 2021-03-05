//
//  CustomNavBarView.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/5/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureNavigationBar(withTitle title: String, largeTitle: Bool, backgroundColor: UIColor, titleColor: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        appearance.backgroundColor = backgroundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = largeTitle
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
}
