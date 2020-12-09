//
//  LoginVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBackground()
//        setupKeyboard()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.emailTextField.inputAccessoryView = toolbar
        self.passwordTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupBackground() {
        navigationController?.isNavigationBarHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "loginBackground")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }

    var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "YokeLogo-1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let introductionLabel: UILabel = {
        let label = UILabel()
        label.text = "In need of a chef? Looking for gigs as a chef? You came to the right place"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.darkGray
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.darkGray
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.mainColor()
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.mainColor().withAlphaComponent(0.8)
        }
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.mainColor().withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.secondaryColor()
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
    
    @objc func handleForgotPassword() {
        let vc = ForgotPasswordVC()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true, completion: nil)
//        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
//        forgotPasswordAlert.addTextField { (textField) in
//            textField.placeholder = "Enter email address"
//        }
//        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
//            let resetEmail = forgotPasswordAlert.textFields?.first?.text
//            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
//                if error != nil{
//                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
//                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(resetFailedAlert, animated: true, completion: nil)
//                }else {
//                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
//                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    self.present(resetEmailSentAlert, animated: true, completion: nil)
//                }
//            })
//        }))
//        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        spinner.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in

            if let err = err {
                Auth.auth().handleFirebaseErrors(error: err, vc: self)
                return
            }
            guard let mainTabBarController = self.view.window!.rootViewController as? MainTabBarController else {return}
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
            self.spinner.stopAnimating()
        })
    }

    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.layer.shadowColor = UIColor.black.cgColor
        button.titleLabel?.layer.shadowRadius = 1
        button.titleLabel?.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.titleLabel?.layer.shadowOpacity = 0.8
        button.titleLabel?.layer.masksToBounds = false
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp() {
        let signupVC = SignupVC()
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    fileprivate func setupViews() {
        
        view.addSubview(logoView)
        logoView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.layer.cornerRadius = 200 / 2
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: logoView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 250)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 20, paddingRight: 0, width: 0, height: 0)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
    

    
    
    
    
    
    

