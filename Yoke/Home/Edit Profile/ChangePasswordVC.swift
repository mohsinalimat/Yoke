//
//  ChangePasswordVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "Change Password"
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.oldPasswordTextField.frame.height))
        oldPasswordTextField.leftView = paddingView
        oldPasswordTextField.leftViewMode = UITextField.ViewMode.always
        
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.newPasswordTextField.frame.height))
        newPasswordTextField.leftView = paddingView2
        newPasswordTextField.leftViewMode = UITextField.ViewMode.always
        
        let stackView = UIStackView(arrangedSubviews: [oldPasswordTextField, newPasswordTextField])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 80)
        
        setupNavTitleAndBarButtonItems()
        
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Change Password"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleChangePassword))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor()
        return view
    }()

    let oldPasswordTextField: UITextField = {
        let text = UITextField()
        text.isSecureTextEntry = true
        text.textColor = UIColor.black
        text.attributedPlaceholder = NSAttributedString(string:"Old Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let newPasswordTextField: UITextField = {
        let text = UITextField()
        text.isSecureTextEntry = true
        text.textColor = UIColor.black
        text.attributedPlaceholder = NSAttributedString(string:"New Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    @objc func handleTextInputChange() {
        if (newPasswordTextField.text?.isEmpty)! || (oldPasswordTextField.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    @objc func handleChangePassword() {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: oldPasswordTextField.text!)
        user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
            if error != nil {
                // An error happened.
            }else{
                user?.updatePassword(to: self.newPasswordTextField.text!, completion: nil)
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func handleAlert() {
        let alertAction = UIAlertController(title: "Incorrect Password", message: "Please try again", preferredStyle: .actionSheet)
        let destroyAction = UIAlertAction(title: "Ok", style: .destructive) { action in
        }
        
        alertAction.addAction(destroyAction)
        self.present(alertAction, animated: true)
    }
}
