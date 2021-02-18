//
//  ChangeEmailVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class ChangeEmailVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "Change Email"
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.emailTextField.frame.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = UITextField.ViewMode.always
        
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.passwordTextField.frame.height))
        passwordTextField.leftView = paddingView2
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 150, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 80)
        setupNavTitleAndBarButtonItems()
        
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Change Email"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleChangeEmail))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.isSecureTextEntry = true
        text.textColor = UIColor.black
        text.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let emailTextField: UITextField = {
        let text = UITextField()
        text.textColor = UIColor.black
        text.attributedPlaceholder = NSAttributedString(string: "New Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    @objc func handleTextInputChange() {
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    @objc func handleChangeEmail() {
        let user = Auth.auth().currentUser
        let uid = Auth.auth().currentUser?.uid
        
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: passwordTextField.text!)
        
        user?.reauthenticateAndRetrieveData(with: credential, completion: {(authResult, error) in
            if error != nil{
                self.handleAlert()
            } else {
                user?.updateEmail(to: self.emailTextField.text!, completion: nil)
                DataService.instance.updateUserValues(uid: uid!, values: [Constants.Email : self.emailTextField.text! as AnyObject])
                Database.database().reference().child(Constants.Users).child(uid!).updateChildValues([Constants.Email: self.emailTextField.text!])
                self.dismiss(animated: true, completion: nil)
            }
        })
        
//        user?.reauthenticate(with: credential, completion: { (error) in
//            if error != nil{
//                self.handleAlert()
//            }else{
//                user?.updateEmail(self.emailTextField.text!, completion: nil)
//                DataService.instance.updateChefValues(uid: uid!, values: [Constants.Email : self.emailTextField.text! as AnyObject])
//                self.dismiss(animated: true, completion: nil)
//            }
//        })
    }
    
    func handleAlert() {
        let alertAction = UIAlertController(title: "Incorrect Password", message: "Please try again", preferredStyle: .actionSheet)
        let destroyAction = UIAlertAction(title: "Ok", style: .destructive) { action in
        }
        
        alertAction.addAction(destroyAction)
        self.present(alertAction, animated: true)
    }

}
