//
//  EditProfileVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    var uid = Auth.auth().currentUser?.uid
    var pickerData = ["Manhattan, NY" , "Brooklyn, NY" , "The Bronx, NY" , "Queens, NY", "Staten Island, NY", "Jersey City, NJ", "Hoboken, NJ", "Harrison, NJ", "Newark, NJ"]
    var isChef: Bool?
    
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            
            guard let coverImageUrl = user?.ProfileCoverUrl else {return}
            coverImageView.loadImage(urlString: coverImageUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        aboutTextView.delegate = self
        
        let emailTap = UITapGestureRecognizer(target: self, action: #selector(self.changeEmailButton(_:)))
        emailTextLabel.addGestureRecognizer(emailTap)

        setupNavTitleAndBarButtonItems()
        setupProfileImageButtons()
        setupInputFieldsAndButtons()
        handleImageUpdates()
        getUserProfile()
//        setupKeyboard()
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.aboutTextView.inputAccessoryView = toolbar
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
    
    func handleImageUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdate), name: CustomCoverImageVC.updateNotificationName, object: nil)
    }
    
    @objc func handleUpdate() {
        getUserProfile()
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Edit Profile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc func changeEmailButton(_ sender: UITapGestureRecognizer) {
        let changeEmail = ChangeEmailVC()
        navigationController?.pushViewController(changeEmail, animated: true)
        print("Please Help!")
    }
    
    func getUserProfile() {
        Database.database().reference().child(Constants.Users).child(self.uid!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let uid = Auth.auth().currentUser?.uid
                let user = User(uid: uid!, dictionary: dictionary)
                self.usernameTextField.text = user.username
                self.emailTextLabel.text = user.email
//                self.locationTextLabel.text = user.location
                self.aboutTextView.text = user.aboutUser
                self.profileImageView.loadImage(urlString: user.profileImageUrl)
                self.coverImageView.loadImage(urlString: user.ProfileCoverUrl)
                
                if user.location == "" {
                    self.locationTextLabel.text = "Choose Location"
                } else {
                   self.locationTextLabel.text = user.location
                }
                
                if user.aboutUser == "" {
                    self.aboutTextView.placeholder = "Tell us a litte about yourself"
                }
            }
            
        })
    }
    
    //MARK: Views
    
    let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("EDIT +", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangePhoto), for: .touchUpInside)
        return button
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        return image
    }()
    
    let coverImageView: CustomImageView = {
        let image = CustomImageView()
        image.backgroundColor = UIColor.mainColor()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.opacity = 0.3
        return image
    }()
    
    let editBannerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Change Cover Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .right
        button.titleEdgeInsets = UIEdgeInsets.init(top: 70, left: 0, bottom: 0, right: 20)
        button.addTarget(self, action: #selector(handleChangeBanner), for: .touchUpInside)
        return button
    }()
    
    let emailTextLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "email"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel!.font =  UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleChangePassword), for: .touchUpInside)
        return button
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let usernameTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.darkGray
        text.textAlignment = .right
        text.translatesAutoresizingMaskIntoConstraints = false
        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        return picker
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationTextLabel: UITextView = {
        let label = UITextView()
        label.text = "Choose Location"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = UIColor.darkGray
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isEditable = false
        return label
    }()
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.text = "About"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let aboutTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let chefLabel: UILabel = {
        let label = UILabel()
        label.text = "Chef Preferences"
        label.textColor = UIColor.darkGray
        label.numberOfLines = 2
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchTypeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel!.font =  UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        button.setImage(UIImage(named: "indicator"), for: .normal)
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let privacyLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let privacyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel!.font =  UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        button.setImage(UIImage(named: "indicator"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrivacy), for: .touchUpInside)
        return button
    }()
    
    let helpLabel: UILabel = {
        let label = UILabel()
        label.text = "Help Center"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let helpButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel!.font =  UIFont.systemFont(ofSize: 14)
        button.contentHorizontalAlignment = .right
        button.setImage(UIImage(named: "indicator"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(handlePrivacy), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate func setupProfileImageButtons() {
        
        view.addSubview(editBannerButton)
        view.addSubview(coverImageView)
        view.addSubview(profileImageView)
        view.addSubview(changePhotoButton)
        
        editBannerButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 160)
        
        coverImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 160)
        
        
        profileImageView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 95, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        //        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 50
        
        changePhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 95, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        //        changePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(self.scrollView)
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: 750)
        
        self.scrollView.anchor(top: changePhotoButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupInputFieldsAndButtons() {
        
        let changeEmailView = UIStackView(arrangedSubviews: [emailLabel, emailTextLabel])
        changeEmailView.distribution = .fill
        changeEmailView.axis = .horizontal
        changeEmailView.spacing = 0
        self.scrollView.addSubview(changeEmailView)
        changeEmailView.anchor(top: self.scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 40)
        changeEmailView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let changePasswordView = UIStackView(arrangedSubviews: [passwordLabel, changePasswordButton])
        changePasswordView.distribution = .fill
        changePasswordView.axis = .horizontal
        changePasswordView.spacing = 0
        self.scrollView.addSubview(changePasswordView)
        changePasswordView.anchor(top: changeEmailView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 40)
        changePasswordView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let usernameView = UIStackView(arrangedSubviews: [usernameLabel, usernameTextField])
        usernameView.distribution = .fill
        usernameView.axis = .horizontal
        usernameView.spacing = 0
        self.scrollView.addSubview(usernameView)
        usernameView.anchor(top: changePasswordView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 50)
        usernameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let locationView = UIStackView(arrangedSubviews: [locationLabel, locationTextLabel])
        locationView.distribution = .fill
        locationView.axis = .horizontal
        locationView.spacing = 0
        self.scrollView.addSubview(locationView)
        locationView.anchor(top: usernameView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 40)
        locationView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let cusineView = UIStackView(arrangedSubviews: [chefLabel, searchTypeButton])
        cusineView.distribution = .fill
        cusineView.axis = .horizontal
        cusineView.spacing = 0
       self.scrollView.addSubview(cusineView)
        cusineView.anchor(top: locationView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 40)
        cusineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

//        let aboutView = UIStackView(arrangedSubviews: [aboutLabel, aboutTextView])
//        aboutView.distribution = .fill
//        aboutView.axis = .vertical
//        aboutView.spacing = 0
        self.scrollView.addSubview(aboutLabel)
        aboutLabel.anchor(top: cusineView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 40)
//        aboutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.scrollView.addSubview(aboutTextView)
        aboutTextView.anchor(top: aboutLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 20, paddingRight: 25, width: 0, height: 100)

        self.scrollView.addSubview(countLabel)
        countLabel.anchor(top: aboutTextView.bottomAnchor, left: nil, bottom: nil, right: aboutTextView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        let privacyView = UIStackView(arrangedSubviews: [privacyLabel, privacyButton])
        privacyView.distribution = .fill
        privacyView.axis = .horizontal
        privacyView.spacing = 0
        self.scrollView.addSubview(privacyView)
        privacyView.anchor(top: countLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 40)
        privacyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        let helpView = UIStackView(arrangedSubviews: [helpLabel, helpButton])
        helpView.distribution = .fill
        helpView.axis = .horizontal
        helpView.spacing = 0
        self.scrollView.addSubview(helpView)
        helpView.anchor(top: privacyView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 40)
        helpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.scrollView.addSubview(logoutButton)
        logoutButton.anchor(top: helpView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: 0, height: 50)

        self.scrollView.addSubview(deleteProfileButton)
        deleteProfileButton.anchor(top: logoutButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: 0, height: 50)
        
        setupPickerView()
        
    }
    
    // picker view and setup
    func setupPickerView(){
        self.locationPicker.delegate = self
        self.locationPicker.dataSource = self
        locationTextLabel.inputView = self.locationPicker
        
        // ToolBar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = UIColor.mainColor()
        toolBar.sizeToFit()
        

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Select your location"
        let labelButton = UIBarButtonItem(customView: label)
        
        locationPicker.setValue(UIColor.darkGray, forKeyPath: "textColor")
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EditProfileVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditProfileVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, labelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        locationTextLabel.inputAccessoryView = toolBar
        
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
        self.locationTextLabel.text = pickerData[row]
    }

    @objc func doneClick() {
        locationTextLabel.resignFirstResponder()
    }
    @objc func cancelClick() {
        locationTextLabel.resignFirstResponder()
    }
    
    //MARK: Functions
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(200 - aboutTextView.text.count) characters left"
    }
    
    let characterLimit = 200
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = aboutTextView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)
        
        return updatedText.count <= characterLimit
    }
    
    @objc func handleLocation(_ sender: UITapGestureRecognizer) {
        if locationPicker.isHidden == true {
            locationPicker.isHidden = false
        } else {
            locationPicker.isHidden = true
        }
    }
    
    @objc func handlePrivacy() {
        let privacyVC = PrivacyVC()
        navigationController?.pushViewController(privacyVC, animated: true)
    }
    
    @objc func handleSearch() {
        let chefPreferencesVC = ChefPreferencesVC()
        navigationController?.pushViewController(chefPreferencesVC, animated: true)
    }
    
    @objc func handleChangeBanner() {
        let changeCover = CustomCoverImageVC()
        navigationController?.pushViewController(changeCover, animated: true)
    }
    
    @objc func handleChangePhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
//        let changeProfilePhoto = ChangeProfileImageVC(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(changeProfilePhoto, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            changePhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            changePhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        changePhotoButton.layer.cornerRadius = changePhotoButton.frame.width/2
        changePhotoButton.layer.masksToBounds = true
        changePhotoButton.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleChangePassword() {
        let changePassword = ChangePasswordVC()
        navigationController?.pushViewController(changePassword, animated: true)
    }
    
//    @objc func handleAbout() {
//        let about = ChangeAboutVC()
//        navigationController?.pushViewController(about, animated: true)
//    }
    
    @objc func handleTextInputChange() {
        let isFormValid = usernameTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
//            saveButton.isEnabled = true
//            saveButton.backgroundColor = .black
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
//            saveButton.isEnabled = false
//            saveButton.backgroundColor = UIColor.lightGray
        }
        
    }
    
    //MARK: Handle Save
    
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    @objc func handleSave() {
        self.saveUser()
        NotificationCenter.default.post(name: EditProfileVC.updateNotificationName, object: nil)

        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        let alert = UIAlertController(title: "Profile Updated", message: "Your profile has successfully been updated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func saveUser() {
        DataService.instance.updateUserValues(uid: self.uid!, values: [Constants.Username: self.usernameTextField.text as AnyObject, Constants.Location: locationTextLabel.text as AnyObject, Constants.About: aboutTextView.text as AnyObject])
        guard let image = self.changePhotoButton.imageView?.image else { return }
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(Constants.ProfileImages).child("\(imageName).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("print error")
                }
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to retrieve downloadURL:", err)
                        return
                    }
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }

                    let values = [Constants.ProfileImageUrl: profileImageUrl]
                    DataService.instance.updateUserValues(uid: self.uid!, values: values as [String : AnyObject])
                })

            })
        }
    }
    
    //MARK: logout
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        //        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.backgroundColor = UIColor.mainColor()
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLogout() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            do {
                try Auth.auth().signOut()
                
                //what happens? we need to present some kind of login controller
                let loginController = LoginVC()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutErr {
                print("Failed to sign out:", signOutErr)
            }
            
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Delete Button and Function
    let deleteProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Account", for: .normal)
        //        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleDeleteAccount), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleDeleteAccount() {
        let user = Auth.auth().currentUser
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let deleteRef = Database.database().reference().child(Constants.Users)
        
        deleteRef.child(uid).removeValue { (error, ref) in
            if error != nil {
                print("error \(String(describing: error))")
            }
        }
        
        user?.delete(completion: { (error) in
            if let error = error {
                print(error)
            } else {
                
                let login = LoginVC()
                let navController = UINavigationController(rootViewController: login)
                self.present(navController, animated: true, completion: nil)
            }
        })
        
        let deleteUser = Auth.auth().currentUser
        
        deleteUser?.delete { error in
            if error != nil {
                // An error happened.
            } else {
                // Account deleted.
            }
        }

        
    }
    
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
