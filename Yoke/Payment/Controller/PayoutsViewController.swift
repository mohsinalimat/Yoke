//
//  PayoutsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 5/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class PayoutsViewController: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        checkIfUserIsChef()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Stripe Payouts", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(backgroundViews)
        view.addSubview(stripeDashboardButton)
    }
    
    func constrainViews() {
        backgroundViews.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 50, paddingRight: 10, height: 200)
        stripeDashboardButton.anchor(top: backgroundViews.topAnchor, left: backgroundViews.leftAnchor, bottom: nil, right: backgroundViews.rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
    }
    
    func checkIfUserIsChef() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserController.shared.fetchUserWithUID(uid: uid) { user in
            if user.isChef == true {
                self.stripeDashboardButton.setTitle("Stripe Dashboard", for: .normal)
                self.stripeDashboardButton.addTarget(self, action: #selector(self.handleStripe), for: .touchUpInside)
            } else {
                self.stripeDashboardButton.setTitle("Connect to Stripe", for: .normal)
                self.stripeDashboardButton.addTarget(self, action: #selector(self.handleStripe), for: .touchUpInside)
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleStripe() {
        let createStripeAccountVC = StripeAccountViewController()
        navigationController?.pushViewController(createStripeAccountVC, animated: true)
    }

    //MARK: - Views
    let backgroundViews: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    var stripeDashboardButton: UIButton = {
        let button = UIButton()
        button.setTitle("Go to Stripe dashboard", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        return button
    }()
   

}
