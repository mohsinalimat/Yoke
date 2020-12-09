//
//  PrivacyVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//
import UIKit

class PrivacyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
    }
    
    func setupViews() {
        navigationItem.title = "Privacy"
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        let stackView = UIStackView(arrangedSubviews: [notificationsLabel, notificationsSwitch])
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.spacing = 0
        view.addSubview(stackView)
        stackView.anchor(top: navView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor()
        return view
    }()
    
    let notificationsLabel: UILabel = {
        let label = UILabel()
        label.text = "Notifications"
        label.textColor = UIColor.black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    var notificationsSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.black
        switchBool.onTintColor = UIColor.black
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(notificationsSwitch(notificationsSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    @objc func notificationsSwitch(notificationsSwitchChanged: UISwitch) {
        print("switch toggled")
    }


}
