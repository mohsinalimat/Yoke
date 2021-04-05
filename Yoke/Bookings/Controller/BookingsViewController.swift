//
//  BookingsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/5/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController {

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Bookings", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
        let filterIcon = UIImage(named: "filterOrange")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.image = filterIcon
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(handleFilter))
    }

}
