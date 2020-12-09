//
//  ForgotPasswordVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 5/29/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(popUpView)
        popUpView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: view.frame.width, height: 0)
        popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(textLabel)
        textLabel.anchor(top: popUpView.topAnchor, left: popUpView.leftAnchor, bottom: nil, right: popUpView.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 80)
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: textLabel.bottomAnchor, left: popUpView.leftAnchor, bottom: nil, right: popUpView.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 30)
        
        let stackView = UIStackView(arrangedSubviews: [cancelButton, resetButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        view.addSubview(stackView)
        stackView.anchor(top: emailTextField.bottomAnchor, left: popUpView.leftAnchor, bottom: popUpView.bottomAnchor, right: popUpView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 50)
    }

    let popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password? Enter your email below and check your inbox for instructions."
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.mainColor()
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
//        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.secondaryColor()
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    let resetButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.secondaryColor()
        button.setTitle("Reset Password", for: .normal)
        button.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        return button
    }()
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleReset() {
        guard let email = emailTextField.text else {return}
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                self.handleFirebaseErrors(error: error)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleFirebaseErrors(error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }

}
