//
//  PayoutsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 5/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class PayoutsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Stripe Payouts", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    //MARK: - Selectors
    @objc func handleStripe() {
        let createStripeAccountVC = StripeAccountViewController()
        navigationController?.pushViewController(createStripeAccountVC, animated: true)
    }

   

}
