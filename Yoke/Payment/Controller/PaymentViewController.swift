//
//  PaymentViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(accountButton)
        accountButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: 50)
        
    }
    
    @objc func handleSend() {
        let withdrawl = CreateStripeAccountVC()
        navigationController?.pushViewController(withdrawl, animated: true)
    }
    
    var accountButton: UIButton = {
        let button = UIButton()
        // add decline X
        button.setTitle("account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()

}
