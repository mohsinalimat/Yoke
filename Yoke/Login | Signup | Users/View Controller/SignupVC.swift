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

class SignupVC: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let imagePicker = UIImagePickerController()
    
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
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(signUpButton)
        constrainViews()
    }
    
    func constrainViews() {
        addImageButton.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 200)
        addImageButton.layer.cornerRadius = 100
        addImageButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        stackView.anchor(top: addImageButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, height: 300)
        alreadyHaveAccountButton.anchor(top: stackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
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
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            
            if let err = error {
                Auth.auth().handleFirebaseErrors(error: err, vc: self)
                return
            }
            
            guard let image = self.addImageButton.imageView?.image else { return }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child(Constants.ProfileImages).child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    Auth.auth().handleFirebaseErrors(error: err, vc: self)
                    return
                }
  
                storageRef.downloadURL(completion: { [self] (downloadURL, err) in
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    guard let uid = user?.user.uid else { return }
 
                    let dictionaryValues = [Constants.Email: email, Constants.Username: username, Constants.ProfileImageUrl: profileImageUrl, Constants.ProfileCoverUrl: "", Constants.UserRate: 0] as [String : Any]
                    let values = [uid: dictionaryValues]

                    DataService.instance.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    
                    let getUser = StripeUser.init(id: uid, customer_id: "", email: email)
                    self.createFirestoreUser(stripeUser: getUser)
                    self.handleLoginToHome()
//                    guard let mainTabBarController = UIApplication.shared.windows.first { $0.isKeyWindow } as? MainTabBarController else { return }
//
//                    mainTabBarController.setupViewControllers()
//
//                    self.dismiss(animated: true, completion: nil)
                })
            })
            
        })
    }
    
    func createFirestoreUser(stripeUser: StripeUser) {
        let ref = Firestore.firestore().collection("stripe_customers").document(stripeUser.id)
        let data = StripeUser.modelToData(customer_id: stripeUser)
        
        ref.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFirebaseErrors(error: error, vc: self)
            }
        }
        
    }
    
    func handleLoginToHome() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let mainTabBarController = self?.view.window!.rootViewController as? MainTabBarController else {return}
            mainTabBarController.setupViewControllers()
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleAlreadyHaveAccount() {
        let loginVC = LoginVC()
        self.view.window?.rootViewController = loginVC
        self.view.window?.makeKeyAndVisible()
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
    
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Member","Chef"])
        seg.layer.borderColor = UIColor.black.cgColor
        seg.layer.borderWidth = 1
        seg.layer.cornerRadius = 5.0
        seg.backgroundColor = .white
        seg.tintColor = .black
//        seg.addTarget(self, action: "changeColor", for: .valueChanged)
        return seg
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
        
        button.isEnabled = false
        
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
