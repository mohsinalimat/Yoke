//
//  CreateAccountViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 7/29/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import MapKit

class CreateAccountViewController: UIViewController {

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
        view.addSubview(imageView)
        view.addSubview(addImageButton)
        view.addSubview(isChefView)
        isChefView.addArrangedSubview(chefLabel)
        isChefView.addArrangedSubview(chefSwitch)
        view.addSubview(usernameView)
        view.addSubview(usernameTextField)
        view.addSubview(emailView)
        view.addSubview(emailTextField)
        view.addSubview(passwordView)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordView)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signUpButton)
        view.addSubview(alreadyHaveAccountButton)
        view.addSubview(myActivityIndicator)
        constrainViews()
    }
    
    func constrainViews() {
        imageView.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        imageView.layer.cornerRadius = 75
        imageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        addImageButton.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        addImageButton.layer.cornerRadius = 75
        addImageButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        isChefView.anchor(top: addImageButton.bottomAnchor, left: usernameView.leftAnchor, bottom: nil, right: usernameView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        usernameView.anchor(top: isChefView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        usernameTextField.anchor(top: usernameView.topAnchor, left: usernameView.leftAnchor, bottom: usernameView.bottomAnchor, right: usernameView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        emailView.anchor(top: usernameView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        emailTextField.anchor(top: emailView.topAnchor, left: emailView.leftAnchor, bottom: emailView.bottomAnchor, right: emailView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        passwordView.anchor(top: emailView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        passwordTextField.anchor(top: passwordView.topAnchor, left: passwordView.leftAnchor, bottom: passwordView.bottomAnchor, right: passwordView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        confirmPasswordView.anchor(top: passwordView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        confirmPasswordTextField.anchor(top: confirmPasswordView.topAnchor, left: confirmPasswordView.leftAnchor, bottom: confirmPasswordView.bottomAnchor, right: confirmPasswordView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        signUpButton.anchor(top: confirmPasswordView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        alreadyHaveAccountButton.anchor(top: signUpButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)
        myActivityIndicator.center = view.center
    }
    
    func setupBackground() {
        navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.white
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

    func handleLoginToHome() {
        myActivityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.5) { [weak self] in
            DispatchQueue.main.async {
                let homeVC = MainTabBarController()
                self?.view.window?.rootViewController = homeVC
                self?.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    func deleteAnonymousAccount() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserController.shared.deleteAnonymousAccountWith(uid: uid) { result in
            switch result {
            case true:
                print("Anonymous account deleted")
            case false:
                print("Error in deleting anonymous account")
            }
        }
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            print("Error in deleting user \(error.localizedDescription)")
          } else {
            print("anonymous account user deleted")
          }
        }

    }
    
    //MARK: - Selectors
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
        self.deleteAnonymousAccount()
        UserController.shared.createUserWith(email: email, username: username, password: password, image: image, isChef: self.isChef) { (result) in
            switch result {
            case true:
                self.handleLoginToHome()
                self.myActivityIndicator.stopAnimating()
            case false:
                print("error in signup: \(Error.self)")
            }
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
    let imageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let addImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add Photo", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor.LightGrayBg()
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        button.layer.borderWidth = 0.5
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleAddProfileImageViewTapped), for: .touchUpInside)
        return button
    }()
    
    let chefLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign up as a chef?"
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    var chefSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.orangeColor()
        switchBool.onTintColor = UIColor.orangeColor()
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(chefSwitch(chefSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    let isChefView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let usernameView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.LightGrayBg()
        return view
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Name"
        textField.textColor = UIColor.orangeColor()
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let emailView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.LightGrayBg()
        return view
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Email"
        textField.textColor = UIColor.orangeColor()
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.layer.cornerRadius = 10
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    let passwordView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.LightGrayBg()
        return view
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "password"
        textField.textColor = UIColor.orangeColor()
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    let confirmPasswordView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.LightGrayBg()
        return view
    }()

    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.placeholder = "Confirm Password"
        textField.textColor = UIColor.orangeColor()
        textField.keyboardType = UIKeyboardType.emailAddress
        textField.layer.cornerRadius = 10
        return textField
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
            
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.gray])
            
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.orangeColor()
                ]))
            
        button.setAttributedTitle(attributedTitle, for: .normal)
            
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
        
}

extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension CreateAccountViewController: UITextFieldDelegate {
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
