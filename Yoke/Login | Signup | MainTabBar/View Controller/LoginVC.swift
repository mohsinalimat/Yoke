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
import GoogleSignIn
import AuthenticationServices
import CryptoKit

class LoginVC: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    fileprivate var currentNonce: String?
    private let locationManager = LocationManager()

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
        setupGoogle()
    }
    
    //MARK: - Helper Functions
    fileprivate func setupViews() {
        view.addSubview(logoView)
        view.addSubview(stackView)
        view.addSubview(introductionLabel)
        view.addSubview(dontHaveAccountButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(signInButtonsStackView)
        view.addSubview(signInOptionLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
        signInButtonsStackView.addArrangedSubview(googleSignUpButton)
        signInButtonsStackView.addArrangedSubview(appleSignUpButton)
        constrainViews()
    }
    
    func constrainViews() {
        logoView.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        logoView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        introductionLabel.anchor(top: logoView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        stackView.anchor(top: introductionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 180)
        dontHaveAccountButton.anchor(top: stackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        forgotPasswordButton.anchor(top: dontHaveAccountButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        signInOptionLabel.anchor(top: forgotPasswordButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        signInButtonsStackView.anchor(top: signInOptionLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 195, height: 75)
        signInButtonsStackView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
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
    
    @objc func handleSignIn() {
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
            let homeVC = WelcomeVC()
            self?.view.window?.rootViewController = homeVC
            self?.view.window?.makeKeyAndVisible()
//            let homeVC = MainTabBarController()
//            self?.view.window?.rootViewController = homeVC
//            self?.view.window?.makeKeyAndVisible()
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
        label.text = "Sign in with email:"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let signInOptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Or sign in with:"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        textField.font = UIFont.systemFont(ofSize: 17)
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
        textField.font = UIFont.systemFont(ofSize: 17)
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
    
    let signInButtonsStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign up with email", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white
            ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = UIColor.yellowColor()?.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
        return button
    }()
    
    let googleSignUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "btn_google_light_normal_ios"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        return button
    }()
    
    let appleSignUpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "iTunesArtwork"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleAppleSignIn), for: .touchUpInside)
        return button
    }()
    
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
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

@available(iOS 13.0, *)
extension LoginVC: ASAuthorizationControllerDelegate {
    
    @objc func handleAppleSignIn() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
                
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
            
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    print(error?.localizedDescription ?? "")
                    return
                }
                guard let user = authResult?.user else { return }
                let email = user.email ?? ""
                let username = user.displayName ?? ""
                guard let uid = Auth.auth().currentUser?.uid else { return }
                UserController.shared.checkIfUserExist(uid: uid) { (result) in
                    switch result {
                    case true:
                        self.handleLoginToHome()
                    case false:
                        guard let exposedLocation = self.locationManager.exposedLocation else { return }
                        self.locationManager.getPlace(for: exposedLocation) { placemark in
                            guard let placemark = placemark else { return }
                            var output = ""
                            if let town = placemark.locality {
                                output = output + "\n\(town)"
                            }
                            if let state = placemark.administrativeArea {
                                output = output + "\n\(state)"
                            }
                            UserController.shared.createUserWithProvider(uid: uid, email: email, username: username, location: output, isChef: false) { (result) in
                                switch result {
                                case true:
                                    self.handleLoginToHome()
                                case false:
                                    print("google sign in problem")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginVC: GIDSignInDelegate {

    @objc func handleGoogleSignIn() {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) {
            (authResult, error) in
            if let error = error {print(error.localizedDescription)
                
            } else {
                guard let uid = Auth.auth().currentUser?.uid,
                      let email = user.profile.email,
                      let username = user.profile.name
                      else { return }
                UserController.shared.checkIfUserExist(uid: uid) { (result) in
                    switch result {
                    case true:
                        self.handleLoginToHome()
                    case false:
                        guard let exposedLocation = self.locationManager.exposedLocation else { return }
                        self.locationManager.getPlace(for: exposedLocation) { placemark in
                            guard let placemark = placemark else { return }
                            var output = ""
                            if let town = placemark.locality {
                                output = output + "\n\(town)"
                            }
                            if let state = placemark.administrativeArea {
                                output = output + "\n\(state)"
                            }
                            UserController.shared.createUserWithProvider(uid: uid, email: email, username: username, location: output, isChef: false) { (result) in
                                switch result {
                                case true:
                                    self.handleLoginToHome()
                                case false:
                                    print("google sign in problem")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setupGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
}

    
    
    
    
    
    

