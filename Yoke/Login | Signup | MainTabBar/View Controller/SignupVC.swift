//
//  SignupVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import MapKit

class SignupVC: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let imagePicker = UIImagePickerController()
    private let locationManager = LocationManager()
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var location: String = ""
    var isChef: Bool = false
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        setupBackground()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddProfileImageView()
        setupKeyboard()
        dismissKeyboardOnTap()
    }

    //MARK: - Helper Functions
    fileprivate func setupViews() {
        view.addSubview(addImageButton)
        view.addSubview(stackView)
        view.addSubview(alreadyHaveAccountButton)
        view.addSubview(isChefView)
        isChefView.addArrangedSubview(chefLabel)
        isChefView.addArrangedSubview(chefSwitch)
        stackView.addArrangedSubview(isChefView)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(signUpButton)
        view.addSubview(myActivityIndicator)
        constrainViews()
    }
    
    func constrainViews() {
        addImageButton.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        addImageButton.layer.cornerRadius = 100
        addImageButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        stackView.anchor(top: addImageButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 300)
        alreadyHaveAccountButton.anchor(top: stackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        myActivityIndicator.center = view.center
    }
    
    func setupBackground() {
        navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.orangeColor()
    }
    
    func changeColor(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.view.backgroundColor = .white
        case 2:
            self.view.backgroundColor = .black
        default:
            self.view.backgroundColor = .black
        }
    }
    
    func setupAddProfileImageView() {
        imagePicker.delegate = self
    }
    
    func confirmPasswordsMatch() {
        let alertController = UIAlertController(title: "Error", message: "Passwords don't Match", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func confirmAllTextFields() {
        let alertController = UIAlertController(title: "Error", message: "Please fill out all the fields", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleAddProfileImageViewTapped(_ sender: UITapGestureRecognizer? = nil) {
        let alertVC = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(cameraAction)
        alertVC.addAction(photoLibraryAction)
        present(alertVC, animated: true)
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty,
              let username = usernameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else { return confirmAllTextFields()}
        guard password == confirmPassword else { return confirmPasswordsMatch()}
        guard let image = self.addImageButton.imageView?.image else { return }
        myActivityIndicator.startAnimating()
        UserController.shared.createUserWith(email: email, username: username, password: password, image: image, isChef: self.isChef) { (result) in
            switch result {
            case true:
                self.handleLoginToHome()
                print("success")
            case false:
                print("error in signup: \(Error.self)")
            }
        }
//        guard let exposedLocation = self.locationManager.exposedLocation else { return }
//        self.locationManager.getPlace(for: exposedLocation) { [self] placemark in
//            guard let placemark = placemark else { return }
//            var output = ""
//            if let locationName = placemark.location {
//                output = output + "\n\(locationName)"
//                // pulls to physical address on mapkit
//            }
//            if let postal = placemark.postalAddress {
//                UserController.shared.createUserWith(email: email, username: username, password: password, image: image, isChef: self.isChef) { (result) in
//                    switch result {
//                    case true:
//                        self.handleLoginToHome()
//                        print("success")
//                    case false:
//                        print("error in signup: \(Error.self)")
//                    }
//                }
//                self.location = output
//                print(self.location)
//            }
//
//        }
    }

    func handleLoginToHome() {
        myActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.5) { [weak self] in
            let homeVC = MainTabBarController()
            self?.view.window?.rootViewController = homeVC
            self?.view.window?.makeKeyAndVisible()
        }
    }
    
    @objc func handleAlreadyHaveAccount() {
        let loginVC = LoginVC()
        self.view.window?.rootViewController = loginVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @objc func chefSwitch(chefSwitchChanged: UISwitch) {
        if chefSwitch.isOn {
            isChef = true
            print("true")
        } else {
            isChef = false
            print("false")
        }
    }
    
    //MARK: - Views
    let addImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add Photo", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleAddProfileImageViewTapped), for: .touchUpInside)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 3
        button.contentMode = .scaleAspectFill
        return button
    }()
    
    let chefLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up as a chef?"
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    let isChefView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillProportionally
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Name",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor() as Any])
        textField.attributedPlaceholder = placeholderText
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.darkGray
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Email",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor() as Any])
        textField.attributedPlaceholder = placeholderText
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
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
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.darkGray
        return textField
    }()

    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Confirm Password",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor() as Any])
        textField.attributedPlaceholder = placeholderText
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.darkGray
        return textField
    }()

    let locationTextField: UITextView = {
        let textField = UITextView()
        textField.placeholder = "Location"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 2
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = UIColor.darkGray
        textField.isEditable = false
        return textField
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.yellowColor()?.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
            
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
            
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white
                ]))
            
        button.setAttributedTitle(attributedTitle, for: .normal)
            
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
        
}

extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        } else {
            let alertVC = UIAlertController(title: "No Camera Acccess", message: "Please allow access to the camera to use this feature", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true)
        }
    }

    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)
        } else {
            let alertVC = UIAlertController(title: "No Photo Acccess", message: "Please allow access to Photos to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            addImageButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            addImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
    
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

extension SignupVC: UITextFieldDelegate {
    func setupKeyboard() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.usernameTextField:
            self.emailTextField.becomeFirstResponder()
        case self.emailTextField:
            self.passwordTextField.becomeFirstResponder()
        case self.passwordTextField:
            self.confirmPasswordTextField.becomeFirstResponder()
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

