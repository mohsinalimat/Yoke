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
import RSKImageCropper

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
    var isUserChef: Bool = false
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    //MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupImagePicker()
        handleUpdatesObserverAndRefresh()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(headerViewBg)
        view.addSubview(swipeIndicator)
        view.addSubview(bannerImageView)
        view.addSubview(editBannerImageButton)
        view.addSubview(profileImageView)
        view.addSubview(editProfileImageButton)
        view.addSubview(settingsLabel)
        view.addSubview(updateButton)
        view.addSubview(scrollView)
        scrollView.addSubview(usernameView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(usernameTextField)
        scrollView.addSubview(locationView)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(locationTextField)
        scrollView.addSubview(locationButton)
        scrollView.addSubview(bioView)
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(bioTextView)
        scrollView.addSubview(chefView)
        scrollView.addSubview(chefLabel)
        scrollView.addSubview(chefSwitch)
        scrollView.addSubview(chefInfoLabel)
        scrollView.addSubview(chefPreferenceButton)
        scrollView.addSubview(changePasswordButton)
        scrollView.addSubview(privacyButton)
        scrollView.addSubview(logoutButton)
        scrollView.addSubview(deleteButton)
    }
    
    func constrainViews() {
        headerViewBg.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: scrollView.topAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        swipeIndicator.anchor(top: headerViewBg.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bannerImageView.anchor(top: swipeIndicator.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: view.frame.width / 2)
        editBannerImageButton.anchor(top: swipeIndicator.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: view.frame.width / 2)
        profileImageView.anchor(top: bannerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 60
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileImageButton.anchor(top: bannerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        editProfileImageButton.layer.cornerRadius = 60
        editProfileImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        settingsLabel.anchor(top: editProfileImageButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        updateButton.anchor(top: editProfileImageButton.bottomAnchor, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.anchor(top: settingsLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        usernameView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: scrollView.frame.width - 20, height: 67)
        usernameLabel.anchor(top: usernameView.topAnchor, left: usernameView.leftAnchor, bottom: nil, right: usernameView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 15)
        usernameTextField.anchor(top: usernameLabel.bottomAnchor, left: usernameView.leftAnchor, bottom: nil, right: usernameView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        locationView.anchor(top: usernameView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: scrollView.frame.width - 20, height: 67)
        locationLabel.anchor(top: locationView.topAnchor, left: locationView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 200, height: 15)
        locationButton.anchor(top: locationView.topAnchor, left: nil, bottom: nil, right: locationView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10)
        locationTextField.anchor(top: locationLabel.bottomAnchor, left: locationView.leftAnchor, bottom: nil, right: locationView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        

        bioView.anchor(top: locationView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: view.frame.width - 20, height: 202)
        bioLabel.anchor(top: bioView.topAnchor, left: bioView.leftAnchor, bottom: nil, right: bioView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: view.frame.width, height: 15)
        bioTextView.anchor(top: bioLabel.bottomAnchor, left: bioView.leftAnchor, bottom: nil, right: bioView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: view.frame.width, height: 150)

        chefView.anchor(top: bioView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: view.frame.width - 20, height: 50)
        chefLabel.anchor(top: nil, left: chefView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 200)
        chefLabel.centerYAnchor.constraint(equalTo: chefView.centerYAnchor).isActive = true
        chefSwitch.anchor(top: nil, left: nil, bottom: nil, right: chefView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10)
        chefSwitch.centerYAnchor.constraint(equalTo: chefView.centerYAnchor).isActive = true
        chefInfoLabel.anchor(top: chefView.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 20)
        chefPreferenceButton.anchor(top: chefInfoLabel.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
        changePasswordButton.anchor(top: chefPreferenceButton.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
        privacyButton.anchor(top: changePasswordButton.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: 45)
        logoutButton.anchor(top: privacyButton.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: 45)
        deleteButton.anchor(top: logoutButton.bottomAnchor, left: scrollView.leftAnchor, bottom: nil, right: scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
    }
    
    fileprivate func fetchUser() {
//        let uid = Auth.auth().currentUser?.uid ?? ""
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            self.setupUserProfile(user: user)
        }
    }
    
    func handleUpdatesObserverAndRefresh() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdate), name: LocationSettingsViewController.updateNotificationName, object: nil)
    }
    
    func setupUserProfile(user: User) {
        guard let city = user.city,
              let state = user.state else { return }
        usernameTextField.text = user.username
        locationTextField.text = "\(city), \(state)"
//        if bioTextView.text.count == 0 {
//            bioTextView.placeholder = "Enter bio here"
//        }
        bioTextView.text = user.bio
        guard let isChef = user.isChef else { return }
        self.chefSwitch.setOn(isChef, animated: true)
        if chefSwitch.isOn {
            chefPreferenceButton.isEnabled = true
            chefPreferenceButton.setTitleColor(UIColor.orangeColor(), for: .normal)
        } else {
            chefPreferenceButton.isEnabled = false
            chefPreferenceButton.setTitleColor(UIColor.orangeColor()?.withAlphaComponent(0.4), for: .normal)
        }
//        let uid = Auth.auth().currentUser?.uid ?? ""
        let imageStorageRef = Storage.storage().reference().child("profileImageUrl/\(uid)")
        imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error == nil, let data = data {
                self.profileImageView.image = UIImage(data: data)
            }
        }
        
        let bannerStorageRef = Storage.storage().reference().child("profileBannerUrl/\(uid)")
        bannerStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if error == nil, let data = data {
                self.bannerImageView.image = UIImage(data: data)
            }
        }
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
    
    func emptyFieldWarning() {
        let alertVC = UIAlertController(title: "Missing Fields", message: "You must fill in all the fields to save", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func saveSuccessful() {
        let alertVC = UIAlertController(title: "Success", message: "Your profile has been updated", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool Beans", style: .default) { (_) in
            self.handleDismiss()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func chefAlert() {
        let alertVC = UIAlertController(title: "Turn chef mode on", message: "By turning chef mode on you will be viewed as a chef. Don't worry if you turn it off, your chef settings data will be saved.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "I want to cook!", style: .default) { (_) in
            self.chefSwitch.isOn = true
            UserController.shared.updateChefAccount(self.uid, isChef: true) { (result) in
                switch result {
                case true:
                    print("updated")
                case false:
                    print("error")
                }
            }
            NotificationCenter.default.post(name: SettingsViewController.updateNotificationName, object: nil)
        }
        let cancelAction = UIAlertAction(title: "I prefer to be served!", style: .cancel) { (_) in
            self.chefSwitch.isOn = false
            UserController.shared.updateChefAccount(self.uid, isChef: false) { (result) in
                switch result {
                case true:
                    print("updated")
                case false:
                    print("error")
                }
            }
            NotificationCenter.default.post(name: SettingsViewController.updateNotificationName, object: nil)
        }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
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
    
    //MARK: - API
    @objc func handleSaveUserInfo() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let bio = bioTextView.text else { return emptyFieldWarning() }
        if chefSwitch.isOn {
            isUserChef = true
        } else {
            isUserChef = false
        }
        UserController.shared.updateUser(uid, username: username, bio: bio, isChef: isUserChef) { (result) in
            switch result {
            case true:
                self.saveSuccessful()
            case false:
                print("error updating user")
            }
        }
        NotificationCenter.default.post(name: SettingsViewController.updateNotificationName, object: nil)
    }
    
    //MARK: - Selectors | API
    @objc func handleUpdate() {
        fetchUser()
    }
    
    @objc func chefSwitch(chefSwitchChanged: UISwitch) {
        if chefSwitch.isOn {
            chefAlert()
            isUserChef = true
            chefPreferenceButton.isEnabled = true
            chefPreferenceButton.setTitleColor(UIColor.orangeColor(), for: .normal)
        } else {
            chefAlert()
            isUserChef = false
            chefPreferenceButton.isEnabled = false
            chefPreferenceButton.setTitleColor(UIColor.orangeColor()?.withAlphaComponent(0.4), for: .normal)
        }
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
    
    @objc func handleLocation() {
        let locationSettings = LocationSettingsViewController()
        present(locationSettings, animated: true)
//        navigationController?.pushViewController(locationSettings, animated: true)
    }
    
    @objc func handleEmailPassword() {
        let Password = PasswordChangeViewController()
        present(Password , animated: true)
    }
    
    @objc func handleChefPreference() {
        let chefPreference = ChefSettingsViewController()
        present(chefPreference , animated: true)
//        navigationController?.pushViewController(locationSettings, animated: true)
    }
    
    //MARK: - Views
    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerViewBg: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.LightGrayBg()?.cgColor
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
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(handleEditBannerImage), for: .touchUpInside)
        return button
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        return image
    }()
    
    let editProfileImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        button.addTarget(self, action: #selector(handleEditProfileImage), for: .touchUpInside)
        return button
    }()
    
    let settingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    let updateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleSaveUserInfo), for: .touchUpInside)
        return button
    }()

    let usernameView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
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
    
    let locationView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
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
    
    let locationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Change location", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleLocation), for: .touchUpInside)
        return button
    }()
    
    let bioView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Bio"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let bioTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        return text
    }()
    
    let chefView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
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
        switchBool.addTarget(self, action: #selector(chefSwitch(chefSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    let chefPreferenceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Chef Settings", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(handleChefPreference), for: .touchUpInside)
        return button
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(handleEmailPassword), for: .touchUpInside)
        return button
    }()
    
    let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.gray.cgColor
//        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.gray.cgColor
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.gray.cgColor
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
                profileImagePicker.allowsEditing = true
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
                bannerImagePicker.allowsEditing = true
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
                UserController.shared.updateUserProfileImage(uid, profileImage: pickedImage) { (result) in
                    switch result {
                    case true:
                        print("success")
                        NotificationCenter.default.post(name: SettingsViewController.updateNotificationName, object: nil)
                    case false:
                        print("error in uploading image")
                    }
                }
            }
        } else {
            if let pickedImage = info[.editedImage] as? UIImage {
                self.bannerImageView.image = pickedImage
                UserController.shared.updateUserBannerImage(uid, bannerImage: pickedImage) { (result) in
                    switch result {
                    case true:
                        print("success")
                        NotificationCenter.default.post(name: SettingsViewController.updateNotificationName, object: nil)
                    case false:
                        print("error in uploading banner")
                    }
                }
            }
        }
        
        picker.dismiss(animated: true)
    }
}
