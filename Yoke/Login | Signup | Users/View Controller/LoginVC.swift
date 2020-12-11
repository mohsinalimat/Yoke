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
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        setupBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        dismissKeyboardOnTap()
    }
    
    //MARK: - Helper Functions
    fileprivate func setupViews() {
        view.addSubview(logoView)
        view.addSubview(stackView)
        view.addSubview(introductionLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        view.addSubview(dontHaveAccountButton)
        view.addSubview(forgotPasswordButton)
        constrainViews()
    }
    
    func constrainViews() {
        logoView.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        logoView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        introductionLabel.anchor(top: logoView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        stackView.anchor(top: introductionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 170)
        dontHaveAccountButton.anchor(top: stackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        forgotPasswordButton.anchor(top: dontHaveAccountButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func setupBackground() {
        navigationController?.isNavigationBarHidden = true
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        UIImage(named: "loginBackground")?.draw(in: self.view.bounds)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        self.view.backgroundColor = UIColor(patternImage: image)
        self.view.backgroundColor = UIColor.orangeColor()
    }

    @objc func handleForgotPassword() {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else { return }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in

            if let err = err {
                Auth.auth().handleFirebaseErrors(error: err, vc: self)
                return
            }
            self.handleLoginToHome()
        })
    }
    
    func handleLoginToHome() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            let homeVC = MainTabBarController()
            self?.view.window?.rootViewController = homeVC
            self?.view.window?.makeKeyAndVisible()
        }
    }

    
    @objc func handleShowSignUp() {
        let signupVC = SignupVC()
        self.view.window?.rootViewController = signupVC
        self.view.window?.makeKeyAndVisible()
    }
    
    //MARK: - Views
    var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "YokeLogo-1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    let introductionLabel: UILabel = {
        let label = UILabel()
        label.text = "In need of a chef? Looking for gigs as a chef? You came to the right place"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Email",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor() as Any])
        textField.attributedPlaceholder = placeholderText
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = UIColor.darkGray
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Password",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor() as Any])
        textField.attributedPlaceholder = placeholderText
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = UIColor.darkGray
        return textField
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white
            ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.yellowColor()?.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
    }()
}
   
extension LoginVC: UITextFieldDelegate {
    func setupKeyboard() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.view.endEditing(true)
        default:
            self.view.endEditing(true)
        }
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }
}

    
    
    
    
    
    

