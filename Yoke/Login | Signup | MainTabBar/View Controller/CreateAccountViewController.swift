//
//  CreateAccountViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 7/29/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CreateAccountViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orangeColor()
        setupViews()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.addSubview(welcomeLabel)
        view.addSubview(chefLabel)
        view.addSubview(chefSubLabel)
        view.addSubview(chefSwitch)
        view.addSubview(continueButton)
        constrainViews()
    }
    func constrainViews() {
        welcomeLabel.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 100, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        chefLabel.anchor(top: welcomeLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        chefSubLabel.anchor(top: chefLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        chefSwitch.anchor(top: chefSubLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        chefSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.anchor(top: chefSwitch.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
    }
    
    func backToLoginVC() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            let loginVC = LoginVC()
            self?.view.window?.rootViewController = loginVC
            self?.view.window?.makeKeyAndVisible()
        }
    }

    @objc func handleContinue() {
        do {
            try Auth.auth().signOut()
            backToLoginVC()
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
    }
    
    @objc func chefSwitch(chefSwitchChanged: UISwitch) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if chefSwitch.isOn {
            Firestore.firestore().collection(Constants.Users).document(uid).setData([Constants.IsChef: true], merge: true)
            print("true")
        } else {
            Firestore.firestore().collection(Constants.Users).document(uid).setData([Constants.IsChef: false], merge: true)
            print("false")
        }
    }
    
    //MARK: - Views
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Thanks for joining Yoke! Just a couple more things then we will send you on your way!"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let chefLabel: UILabel = {
        let label = UILabel()
        label.text = "Would you like to sign up as a chef?"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let chefSubLabel: UILabel = {
        let label = UILabel()
        label.text = "You can always change this in settings"
        label.textColor = UIColor.white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var chefSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.yellowColor()
        switchBool.onTintColor = UIColor.yellowColor()
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(chefSwitch(chefSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    let continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Logout", for: .normal)
        button.backgroundColor = UIColor.yellowColor()?.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return button
    }()
    
}
