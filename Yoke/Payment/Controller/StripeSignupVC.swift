//
//  StripeSignupVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 3/2/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit

class StripeSignupVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.definesPresentationContext = true
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(0.3)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(handleDismiss))
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        view.addSubview(customView)
        var viewFrame = customView.frame
        viewFrame.size.width = view.frame.width - 50
        viewFrame.size.height = 150
        customView.frame = viewFrame
        customView.center = self.view.center
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: customView.topAnchor, left: customView.leftAnchor, bottom: nil, right: customView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        view.addSubview(label)
        label.anchor(top: titleLabel.bottomAnchor, left: customView.leftAnchor, bottom: customView.bottomAnchor, right: customView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 40, paddingRight: 10, width: 0, height: 0)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: nil, left: nil, bottom: customView.topAnchor, right: customView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
    }
    
    var customView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 6
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.darkGray
        label.backgroundColor = .white
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Stripe Account"
        return label
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.orangeColor()
        label.backgroundColor = .white
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "You must setup an account with Stripe to send and receive payments. See Balance and Withdraw to sign up"
        return label
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "Delete"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func stripeSignUp() {
        print("accounted")
        let invoice = WithdrawlVC()
    
        self.present(invoice, animated: true, completion: nil)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    

}
