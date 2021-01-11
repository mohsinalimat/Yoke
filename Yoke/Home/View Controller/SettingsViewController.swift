//
//  SettingsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/6/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Kingfisher

//https://medium.com/@mattkopacz/handling-text-fields-in-table-view-7d50f051368b

class SettingsViewController: UIViewController  {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let profileImagePicker = UIImagePickerController()
    let bannerImagePicker = UIImagePickerController()
    var isProfileImagePicker: Bool = true
    let uid = Auth.auth().currentUser?.uid ?? ""
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigationBar()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupImagePicker()
    }
    
    //MARK: - Helper Functions
    func setupNavigationBar() {
        self.navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleDismiss))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveUserInfo))
    }
    
    fileprivate func fetchUser() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            self.setupUserProfile(user: user)
        }
    }
    
    func setupUserProfile(user: User) {
        usernameTextField.text = user.username
        locationTextField.text = user.location
//        bioTextView.text = user.bio
        let uid = Auth.auth().currentUser?.uid ?? ""
        let imageStorageRef = Storage.storage().reference().child("profileImage/\(uid)")
        imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error == nil, let data = data {
                self.profileImageView.image = UIImage(data: data)
            }
        }
        
        let bannerStorageRef = Storage.storage().reference().child("bannerImage/\(uid)")
        bannerStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error == nil, let data = data {
                self.bannerImageView.image = UIImage(data: data)
            }
        }
    }

    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(scrollView)
        view.addSubview(bannerImageView)
        view.addSubview(editBannerImageButton)
        view.addSubview(profileImageView)
        view.addSubview(editProfileImageButton)
        scrollView.addSubview(usernameView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(locationView)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(locationTextField)
        scrollView.addSubview(bioView)
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(chefView)
        scrollView.addSubview(chefLabel)
        scrollView.addSubview(chefSwitch)
        scrollView.addSubview(chefInfoLabel)
        scrollView.addSubview(logoutButton)
        scrollView.addSubview(deleteButton)
    }
    
    func constrainViews() {
        bannerImageView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: view.frame.width / 3)
        editBannerImageButton.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: view.frame.width / 3)
        profileImageView.anchor(top: bannerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 60
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileImageButton.anchor(top: bannerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        editProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.anchor(top: editProfileImageButton.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        usernameView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 20, height: 67)
        usernameLabel.anchor(top: usernameView.topAnchor, left: usernameView.leftAnchor, bottom: nil, right: usernameView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: view.frame.width, height: 15)
        usernameTextField.anchor(top: usernameLabel.bottomAnchor, left: usernameView.leftAnchor, bottom: nil, right: usernameView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width)
        
        locationView.anchor(top: usernameView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 20, height: 67)
        locationLabel.anchor(top: locationView.topAnchor, left: locationView.leftAnchor, bottom: nil, right: locationView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: view.frame.width, height: 15)
        locationTextField.anchor(top: locationLabel.bottomAnchor, left: locationView.leftAnchor, bottom: nil, right: locationView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width)
        
        bioView.anchor(top: locationView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 20, height: 202)
        bioLabel.anchor(top: bioView.topAnchor, left: bioView.leftAnchor, bottom: nil, right: bioView.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 5, paddingRight: 8, width: view.frame.width, height: 20)
        bioTextView.anchor(top: bioLabel.bottomAnchor, left: bioView.leftAnchor, bottom: nil, right: bioView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: view.frame.width, height: 150)
        
        chefView.anchor(top: bioView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 20, height: 40)
        chefLabel.anchor(top: chefView.topAnchor, left: chefView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 200, height: 20)
        chefSwitch.anchor(top: chefView.topAnchor, left: nil, bottom: chefView.bottomAnchor, right: chefView.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 8)
        chefInfoLabel.anchor(top: chefView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, height: 20)
    }
    
    func setupImagePicker() {
        profileImagePicker.delegate = self
        bannerImagePicker.delegate = self
    }
    
    func backToLoginVC() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            let loginVC = LoginVC()
            self?.view.window?.rootViewController = loginVC
            self?.view.window?.makeKeyAndVisible()
        }
    }

    @objc func handleSaveUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid,
              let username = usernameTextField.text, !username.isEmpty,
              let location = locationTextField.text, !location.isEmpty, let bio = bioTextView.text else { return emptyFieldWarning() }
//        UserController.shared.updateUser(uid, username: username, location: location, bio: bio) { (result) in
//            switch result {
//            case .success(_):
//                self.saveSuccessful()
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func emptyFieldWarning() {
        let alertVC = UIAlertController(title: "Missing Fields", message: "You must fill in all the fields to save", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func saveSuccessful() {
        let alertVC = UIAlertController(title: "Success", message: "Your profile has been updated", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool", style: .default) { (_) in
            self.handleDismiss()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true)
    }
    
    @objc func handleEditBannerImage() {
        isProfileImagePicker = false
        let alertVC = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.profileImagePicker.dismiss(animated: true)
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
    
    @objc func handleEditProfileImage() {
        isProfileImagePicker = true
        let alertVC = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.profileImagePicker.dismiss(animated: true)
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
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            backToLoginVC()
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
    }
    
    @objc func handleDelete() {
        deleteAction()
    }
    
    func deleteAction() {
        let alertVC = UIAlertController(title: "Are your sure you want to delete your account?", message: "You will loose all your data if you choose to delete", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes, let's delete", style: .default) { (_) in
            self.deleteUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(yesAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true)
    }
    
    func deleteUser() {
        guard let user = Auth.auth().currentUser else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        UserController.shared.deleteUserData(uid) { (result) in
//            switch result {
//            case .success(_):
//                user.delete { (error) in
//                    if let error = error {
//                        print(error)
//                    } else {
//                        print("Deleted account")
//                    }
//                    self.backToLoginVC()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    //MARK: - Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bannerImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        return image
    }()
    
    let editBannerImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Banner Image", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleEditBannerImage), for: .touchUpInside)
        return button
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        image.backgroundColor = UIColor.orangeColor()
        return image
    }()
    
    let editProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileImage), for: .touchUpInside)
        return button
    }()

    let usernameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.backgroundColor = .white
        return label
    }()
    
    let usernameTextField: UITextField = {
        let text = UITextField()
        text.textColor = .darkGray
        text.placeholder = "Name here"
        text.textAlignment = .left
        text.backgroundColor = .white
        return text
    }()
    
    let locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let locationTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Location"
        text.textColor = .darkGray
        return text
    }()
    
    let bioView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let bioTextView: UITextView = {
        let text = UITextView()
        text.placeholder = "Enter bio here"
        text.backgroundColor = .clear
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        return text
    }()
    
    let chefView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let chefLabel: UILabel = {
        let label = UILabel()
        label.text = "Switch to chef account"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let chefInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Turning on chef mode allows you to be viewed as a chef."
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var chefSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.orangeColor()
        switchBool.onTintColor = UIColor.orangeColor()
        switchBool.setOn(false, animated: true)
//        switchBool.addTarget(self, action: #selector(chefSwitch(chefSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        return button
    }()
}

//MARK: - Image Picker
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func openCamera() {
        if isProfileImagePicker {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                profileImagePicker.sourceType = .camera
                profileImagePicker.allowsEditing = false
                self.present(profileImagePicker, animated: true)
            } else {
                let alertVC = UIAlertController(title: "No Camera Acccess", message: "Please allow access to the camera to use this feature", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true)
            }
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                bannerImagePicker.sourceType = .camera
                bannerImagePicker.allowsEditing = false
                self.present(bannerImagePicker, animated: true)
            } else {
                let alertVC = UIAlertController(title: "No Camera Acccess", message: "Please allow access to the camera to use this feature", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true)
            }
        }
        
    }

    func openPhotoLibrary() {
        if isProfileImagePicker {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                profileImagePicker.sourceType = .photoLibrary
                profileImagePicker.allowsEditing = true
                self.present(profileImagePicker, animated: true)
            } else {
                let alertVC = UIAlertController(title: "No Photo Acccess", message: "Please allow access to Photos to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true)
            }
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                bannerImagePicker.sourceType = .photoLibrary
                bannerImagePicker.allowsEditing = true
                self.present(bannerImagePicker, animated: true)
            } else {
                let alertVC = UIAlertController(title: "No Photo Acccess", message: "Please allow access to Photos to use this feature.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true)
            }
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if isProfileImagePicker {
            if let pickedImage = info[.editedImage] as? UIImage {
                self.profileImageView.image = pickedImage
//                UserController.shared.updateUserProfileImage(uid, profileImage: pickedImage) { (result) in
//                    switch result {
//                    case .success(_):
//                    print("photo was success")
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
            }
        } else {
            if let pickedImage = info[.editedImage] as? UIImage {
                self.bannerImageView.image = pickedImage
//                UserController.shared.updateUserBannerImage(uid, bannerImage: pickedImage) { (result) in
//                    switch result {
//                    case .success(_):
//                        print("photo was success")
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                    }
//                }
            }
        }
        
        picker.dismiss(animated: true)
    }
}
