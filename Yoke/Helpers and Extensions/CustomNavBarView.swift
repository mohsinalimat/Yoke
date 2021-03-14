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
        guard let orange = UIColor.orangeColor() else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        appearance.titleTextAttributes = [ NSAttributedString.Key.foregroundColor : orange ]
        appearance.backgroundColor = backgroundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = largeTitle
        navigationItem.title = title
        navigationController?.navigationBar.tintColor = orange
        navigationController?.navigationBar.isTranslucent = true
    }
}
