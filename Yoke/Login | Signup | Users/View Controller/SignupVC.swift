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

class SignupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    var pickerData = ["Manhattan, NY" , "Brooklyn, NY" , "The Bronx, NY" , "Queens, NY", "Staten Island, NY", "Jersey City, NJ", "Hoboken, NJ", "Harrison, NJ", "Newark, NJ"]
    
    var salmonCheckImage: UIImage = UIImage(named: "checkmark_salmon")!
    var mossCheckImage: UIImage = UIImage(named: "checkmark_moss")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBackground()
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.emailTextField.inputAccessoryView = toolbar
        self.passwordTextField.inputAccessoryView = toolbar
        self.usernameTextField.inputAccessoryView = toolbar
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
        
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        UIImage(named: "loginBackground")?.draw(in: self.view.bounds)
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        self.view.backgroundColor = UIColor(patternImage: image)
        self.view.backgroundColor = UIColor.orangeColor()
    }

    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        return button
    }()
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
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
    
    @objc func handleTextInputChange() {
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0 && confirmPasswordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.yellowColor()
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.yellowColor()?.withAlphaComponent(0.8)
        }
        
        if passwordTextField.text == confirmPasswordTextField.text {
            passwordTextField.rightView = UIImageView(image: mossCheckImage)
            passwordTextField.rightView?.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
            passwordTextField.rightViewMode = .always
            
            confirmPasswordTextField.rightView = UIImageView(image: mossCheckImage)
            confirmPasswordTextField.rightView?.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
            confirmPasswordTextField.rightViewMode = .always
        } else {
            passwordTextField.rightView = UIImageView(image: salmonCheckImage)
            passwordTextField.rightView?.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
            passwordTextField.rightViewMode = .always
            
            confirmPasswordTextField.rightView = UIImageView(image: salmonCheckImage)
            confirmPasswordTextField.rightView?.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
            confirmPasswordTextField.rightViewMode = .always
        }
    }
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor()])
        textField.attributedPlaceholder = placeholderText
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.darkGray
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Email",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor()])
        textField.attributedPlaceholder = placeholderText
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.darkGray
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor()])
        textField.attributedPlaceholder = placeholderText
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.darkGray
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()

    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        let placeholderText = NSAttributedString(string: "Confirm Password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.orangeColor()])
        textField.attributedPlaceholder = placeholderText
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.darkGray
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    
    
    let locationTextField: UITextView = {
        let textField = UITextView()
        textField.placeholder = "Location"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 2
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = UIColor.darkGray
        textField.isEditable = false
        return textField
    }()
    
    let locationPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    func setupPickerView(){
        
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        locationTextField.inputView = self.locationPicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SignupVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SignupVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        locationTextField.inputAccessoryView = toolBar
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.locationTextField.text = pickerData[row]
    }
    
    @objc func doneClick() {
        locationTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        locationTextField.resignFirstResponder()
    }
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.yellowColor()?.withAlphaComponent(0.8)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        button.isEnabled = false
        
        return button
    }()
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let username = usernameTextField.text, !username.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }

        spinner.startAnimating()

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in
            
            if let err = error {
                Auth.auth().handleFirebaseErrors(error: err, vc: self)
                return
            }
            
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
            
            let filename = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child(Constants.ProfileImages).child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                
                if let err = err {
                    Auth.auth().handleFirebaseErrors(error: err, vc: self)
                    self.spinner.stopAnimating()
                    return
                }
  
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    guard let uid = user?.user.uid else { return }
 
                    let dictionaryValues = [Constants.Email: email, Constants.Username: username, Constants.ProfileImageUrl: profileImageUrl, Constants.ProfileCoverUrl: "", Constants.UserRate: 0] as [String : Any]
                    let values = [uid: dictionaryValues]

                    DataService.instance.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    
                    let getUser = StripeUser.init(id: uid, customer_id: "", email: email)
                    self.createFirestoreUser(stripeUser: getUser)
                    
                    guard let mainTabBarController = UIApplication.shared.windows.first { $0.isKeyWindow } as? MainTabBarController else { return }

                    mainTabBarController.setupViewControllers()
                    self.spinner.stopAnimating()

                    self.dismiss(animated: true, completion: nil)
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
    
    func handleLoginSeg() {
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
        mainTabBarController.setupViewControllers()
        self.dismiss(animated: true, completion: nil)
    }
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
            
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
            
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white
                ]))
            
        button.setAttributedTitle(attributedTitle, for: .normal)
            
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
        
    @objc func handleAlreadyHaveAccount() {
        UIView.animate(withDuration: 1) { [weak self] in
            let loginVC = LoginVC()
            self?.view.window?.rootViewController = loginVC
            self?.view.window?.makeKeyAndVisible()
        }
    }
    
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    fileprivate func setupViews() {
        view.addSubview(plusPhotoButton)
        plusPhotoButton.alignImageTextVertical()
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        plusPhotoButton.layer.cornerRadius = 150 / 2
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField, locationTextField, signUpButton, alreadyHaveAccountButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
            
        view.addSubview(stackView)
            
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 350)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.anchor(top: stackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
        
}
    
// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

