//
//  LoginVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MapKit

class LoginVC: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    private let locationManager = LocationManager()
    let mapView = MKMapView()
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        dismissKeyboardOnTap()
        overrideUserInterfaceStyle = .light
    }
    
    //MARK: - Helper Functions
    fileprivate func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor.white
        view.addSubview(logoView)
        view.addSubview(introductionLabel)
        view.addSubview(emailView)
        view.addSubview(emailTextField)
        view.addSubview(passwordView)
        view.addSubview(passwordTextField)
        view.addSubview(forgotPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(loginAnonymouslyButton)
        view.addSubview(dontHaveAccountButton)
        view.addSubview(myActivityIndicator)
        constrainViews()
    }
    
    func constrainViews() {
        //        backgroundView.frame = view.frame
        logoView.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        introductionLabel.anchor(top: logoView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        emailView.anchor(top: introductionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        emailTextField.anchor(top: emailView.topAnchor, left: emailView.leftAnchor, bottom: emailView.bottomAnchor, right: emailView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        passwordView.anchor(top: emailTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        passwordTextField.anchor(top: passwordView.topAnchor, left: passwordView.leftAnchor, bottom: passwordView.bottomAnchor, right: passwordView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        forgotPasswordButton.anchor(top: passwordTextField.bottomAnchor, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 40)
        loginButton.anchor(top: forgotPasswordButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        loginAnonymouslyButton.anchor(top: loginButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        dontHaveAccountButton.anchor(top: loginAnonymouslyButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        myActivityIndicator.center = view.center
    }
    
    func setupGeofirestore(uid: String) {
        guard let exposedLocation = self.locationManager.exposedLocation else { return }
        self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var output = ""
            if let locationName = placemark.location {
                output = output + "\n\(locationName)"
            }
            self.locationManager.getLocation(forPlaceCalled: output) { location in
                guard let location = location else { return }
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let latitude = center.latitude
                let longitude = center.longitude
                if let postal = placemark.postalAddress {
                    UserController.shared.setUserLocation(uid, city: postal.city, state: postal.state, latitude: latitude, longitude: longitude) { (result) in
                        switch result {
                        case true:
                            print("success")
                        case false:
                            print("failed to save")
                        }
                    }
                }
            }
        }
    }
    
    func handleLoginToHome() {
        self.myActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.5) { [weak self] in
            let homeVC = MainTabBarController()
            self?.view.window?.rootViewController = homeVC
            self?.view.window?.makeKeyAndVisible()
        }
    }
    
    func handleAnonymousLoginToHome() {
        self.myActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.5) { [weak self] in
            let homeVC = AnonymousTabBarController()
            self?.view.window?.rootViewController = homeVC
            self?.view.window?.makeKeyAndVisible()
        }
    }
    
    //MARK: - Selectors
    @objc func handleShowSignUp() {
        let signupVC = SignupVC()
        self.view.window?.rootViewController = signupVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else { return handleLoginError()}
        
        self.myActivityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                self.myActivityIndicator.stopAnimating()
                self.handleError(error)
                print(error.localizedDescription)
                return
            }
            self.handleLoginToHome()
        })
    }
    
    @objc func handleAnonymousLogin() {
        self.myActivityIndicator.startAnimating()
        UserController.shared.createAnonymousUser { result in
            switch result {
            case true:
                self.handleAnonymousLoginToHome()
            case false:
                print("false")
            }
        }
    }
    
    @objc func handleLoginError() {
        if emailTextField.text == "" {
            let loginAlert = UIAlertController(title: "Missing Email", message: "Please enter email", preferredStyle: .alert)
            loginAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(loginAlert, animated: true, completion: nil)
        }
        if passwordTextField.text == ""{
            let loginAlert = UIAlertController(title: "Missing Password", message: "Please enter password", preferredStyle: .alert)
            loginAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(loginAlert, animated: true, completion: nil)
        }
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
    
    //MARK: - Views
    var logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "YokeLogoGradient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        imageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imageView.layer.shadowRadius = 4
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    let introductionLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign in with email:"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    let emailView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Email"
        textField.textColor = UIColor.orangeColor()
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let passwordView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Password"
        textField.textColor = UIColor.orangeColor()
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        return button
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
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.gray])
        attributedTitle.append(NSAttributedString(string: "Sign up with email", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.orangeColor()!
        ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let loginAnonymouslyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Anonymously Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleAnonymousLogin), for: .touchUpInside)
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
