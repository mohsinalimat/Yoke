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
import MapKit

class LoginVC: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let appleButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
    fileprivate var currentNonce: String?
    private let locationManager = LocationManager()
    let mapView = MKMapView()
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
//    var city: String?
//    var state: String?

    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        dismissKeyboardOnTap()
        setupGoogle()
    }
    
    //MARK: - Helper Functions
    fileprivate func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.layer.addSublayer(backgroundView)
        view.addSubview(logoView)
        view.addSubview(introductionLabel)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(forgotPasswordButton)
        view.addSubview(signInButton)
        view.addSubview(dontHaveAccountButton)
        view.addSubview(signInOptionLabel)
        view.addSubview(googleSignUpButton)
        view.addSubview(appleSignUpButton)
        view.addSubview(myActivityIndicator)
        constrainViews()
//        setupBackground()
    }
    
    func constrainViews() {
        backgroundView.frame = view.frame
        logoView.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        logoView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        introductionLabel.anchor(top: logoView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        emailTextField.anchor(top: introductionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        forgotPasswordButton.anchor(top: passwordTextField.bottomAnchor, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 40)
        signInButton.anchor(top: forgotPasswordButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        dontHaveAccountButton.anchor(top: signInButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        signInOptionLabel.anchor(top: dontHaveAccountButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        googleSignUpButton.anchor(top: signInOptionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        appleSignUpButton.anchor(top: googleSignUpButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        
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
        self.myActivityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.handleLoginToHome()
        })
    }

    func handleLoginToHome() {
        self.myActivityIndicator.stopAnimating()
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
    var backgroundView: CAGradientLayer = {
        let view = CAGradientLayer()
        view.colors = [UIColor.orangeColor()?.cgColor ?? "", UIColor.yellowColor()?.cgColor ?? ""]
        view.locations = [0, 1]
        return view
    }()
    
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
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white as Any])
        textField.attributedPlaceholder = placeholderText
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = UIColor.gray
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Password",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white as Any])
        textField.attributedPlaceholder = placeholderText
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.textColor = UIColor.gray
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
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
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
        print("authorizationController passed")
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("appleID Credential")
            guard let nonce = currentNonce else {
                print("error_01")
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("error_02")
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("error_03")
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      accessToken: nonce)
            print("credential \(nonce)")
            myActivityIndicator.startAnimating()
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                print("here")
                if (error != nil) {
                    print("error_04 \(error)")
                    print(error?.localizedDescription ?? "", "this is an error")
                    return
                }
                
                if Auth.auth().currentUser != nil {
                    // User is signed in.
                    print("signed in")
                } else {
                    // No user is signed in.
                    print("not Signed in")
                }
                
//                guard let user = authResult?.user else { return }
//                let email = user.email ?? ""
//                let username = user.displayName ?? ""
//                guard let uid = Auth.auth().currentUser?.uid else { return }
//                UserController.shared.checkIfUserExist(uid: uid) { (result) in
//                    switch result {
//                    case true:
//                        print("error_05")
//                        self.handleLoginToHome()
//                    case false:
//                        UserController.shared.createUserWithProvider(uid: uid, email: email, username: username, isChef: false) { (result) in
//                            switch result {
//                            case true:
//                                print("signing in")
//                                self.setupGeofirestore(uid: uid)
//                                self.handleLoginToHome()
//                            case false:
//                                print("apple sign in problem")
//                            }
//                        }
//                    }
//                }
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
        myActivityIndicator.startAnimating()
        Auth.auth().signInAndRetrieveData(with: credentials) {
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
                        UserController.shared.createUserWithProvider(uid: uid, email: email, username: username, isChef: false) { (result) in
                            switch result {
                            case true:
                                self.setupGeofirestore(uid: uid)
                                self.handleLoginToHome()
                            case false:
                                print("google sign in problem")
                            }
                        }
//                        guard let exposedLocation = self.locationManager.exposedLocation else { return }
//                        self.locationManager.getPlace(for: exposedLocation) { placemark in
//                            guard let placemark = placemark else { return }
//                            guard let city = placemark.locality,
//                                  let state = placemark.administrativeArea else { return }
//                            UserController.shared.createUserWithProvider(uid: uid, email: email, username: username, city: city, state: state, isChef: false) { (result) in
//                                switch result {
//                                case true:
//                                    self.handleLoginToHome()
//                                case false:
//                                    print("google sign in problem")
//                                }
//                            }
//                        }
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

    
    
    
    
    
    

