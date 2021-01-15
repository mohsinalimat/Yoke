//
//  PasswordChangeViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/14/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class PasswordChangeViewController: UIViewController {
    
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
        view.backgroundColor = .white
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        saveButton.isEnabled = false
        view.addSubview(swipeIndicator)
        view.addSubview(passwordLabel)
        view.addSubview(oldPasswordTextField)
        view.addSubview(newPasswordTextField)
        view.addSubview(saveButton)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        passwordLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        passwordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        oldPasswordTextField.anchor(top: passwordLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 45)
        oldPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newPasswordTextField.anchor(top: oldPasswordTextField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 45)
        newPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.anchor(top: newPasswordTextField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 250, height: 45)
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func handleChangePassword() {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPasswordTextField.text!)
        user?.reauthenticate(with: credential, completion: {(authResult, error) in
            if error != nil {
                self.handleAlert()
                print("\(String(describing: error?.localizedDescription))")
            } else {
                user?.updatePassword(to: self.newPasswordTextField.text!, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func handleAlert() {
        let alertController = UIAlertController(title: "Incorrect Password", message: "Please try again", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleTextInputChange() {
        if (newPasswordTextField.text?.isEmpty)! || (oldPasswordTextField.text?.isEmpty)! {
            self.saveButton.isEnabled = false
            self.saveButton.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(0.5)
            
        } else {
            self.saveButton.isEnabled = true
            self.saveButton.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(1)
        }
    }
    
    //MARK: - Views
    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 5
        return view
    }()
    
    var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Password"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    let oldPasswordTextField: UITextField = {
        let text = UITextField()
        text.isSecureTextEntry = true
        text.font = UIFont.systemFont(ofSize: 17)
        text.placeholder = "Old Password"
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.LightGrayBg()
        text.layer.cornerRadius = 5
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let newPasswordTextField: UITextField = {
        let text = UITextField()
        text.isSecureTextEntry = true
        text.font = UIFont.systemFont(ofSize: 17)
        text.placeholder = "New Password"
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.LightGrayBg()
        text.layer.cornerRadius = 5
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        return button
    }()
}
