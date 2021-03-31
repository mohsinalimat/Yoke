//
//  AddMenuViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class AddMenuViewController: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let menuImagePicker = UIImagePickerController()
    var courseType: String = "Appetizer"
    var menuType: String = "Fixed"
    var uid = Auth.auth().currentUser?.uid ?? ""
    var menuExist: Bool = false
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var menu: Menu? {
        didSet {
            fetchMenu()
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
    }
 
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(swipeIndicator)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        view.addSubview(menuLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(menuImageView)
        scrollView.addSubview(menuAddImageButton)
        scrollView.addSubview(dishNameTextField)
        scrollView.addSubview(dishDetailTextField)
        scrollView.addSubview(courseView)
        scrollView.addSubview(courseLabel)
        scrollView.addSubview(courseSegmentedControl)
        scrollView.addSubview(fixedView)
        scrollView.addSubview(fixedLabel)
        scrollView.addSubview(fixedSegmentedControl)
        view.addSubview(myActivityIndicator)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        deleteButton.anchor(top: swipeIndicator.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        menuLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        menuLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
        scrollView.anchor(top: menuLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        menuImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: 300)
        menuAddImageButton.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: 300)
        dishNameTextField.anchor(top: menuImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 45)
        dishDetailTextField.anchor(top: dishNameTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 150)
        courseView.anchor(top: dishDetailTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 80)
        courseLabel.anchor(top: courseView.topAnchor, left: courseView.leftAnchor, bottom: nil, right: courseView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, height: 45)
        courseSegmentedControl.anchor(top: courseLabel.bottomAnchor, left: courseView.leftAnchor, bottom: nil, right: courseView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 30)
        fixedView.anchor(top: courseView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 80)
        fixedLabel.anchor(top: fixedView.topAnchor, left: fixedView.leftAnchor, bottom: nil, right: fixedView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, height: 45)
        fixedSegmentedControl.anchor(top: fixedLabel.bottomAnchor, left: fixedView.leftAnchor, bottom: nil, right: fixedView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 30)
        myActivityIndicator.center = view.center
    }
    
    func fetchMenu() {
        guard let image = menu?.imageUrl else { return }
        menuImageView.loadImage(urlString: image)
        dishNameTextField.text = menu?.name
        dishDetailTextField.text = menu?.detail
        if menu?.courseType == "Appetizer" {
            courseSegmentedControl.selectedSegmentIndex = 0
        } else if menu?.courseType == "Main" {
            courseSegmentedControl.selectedSegmentIndex = 1
        } else if menu?.courseType == "Dessert" {
            courseSegmentedControl.selectedSegmentIndex = 2
        }
        
        if menu?.menuType == "Fixed" {
            fixedSegmentedControl.selectedSegmentIndex = 0
        } else {
            fixedSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    func setupImagePicker() {
        menuImagePicker.delegate = self
    }

    func saveSuccessful() {
        let alertVC = UIAlertController(title: "Success", message: "Your menu item has been added!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool Beans", style: .default) { (_) in
            self.handleDismiss()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
 
    func deleteSuccessful() {
        let alertVC = UIAlertController(title: "Success", message: "Your menu item has been deleted!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool Beans", style: .default) { (_) in
            self.handleDismiss()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    //MARK: - Selectors
    @objc func handleAddImage() {
        let alertVC = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.menuImagePicker.dismiss(animated: true)
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
    
    @objc func handleCourseType(index: Int) {
        if courseSegmentedControl.selectedSegmentIndex == 0 {
            courseType = "Appetizer"
        } else if courseSegmentedControl.selectedSegmentIndex == 1 {
            courseType = "Main"
        } else if courseSegmentedControl.selectedSegmentIndex == 2 {
            courseType = "Dessert"
        }
    }
    
    @objc func handleMenuType(index: Int) {
        if fixedSegmentedControl.selectedSegmentIndex == 0 {
            menuType = "Fixed"
        } else if fixedSegmentedControl.selectedSegmentIndex == 1 {
            menuType = "Sample"
        }
    }
    
    @objc func handleSave() {
        guard let name = dishNameTextField.text, !name.isEmpty,
              let detail = dishDetailTextField.text else { return }
        let image = menuImageView.image
        myActivityIndicator.startAnimating()
        if menuExist == true {
            guard let  menuId = menu?.id,
                  let imageId = menu?.imageId else { return }
            MenuController.shared.updateMenuWith(uid: self.uid, menuId: menuId, imageId: imageId, name: name, detail: detail, courseType: self.courseType, menuType: self.menuType, image: image) { (result) in
                switch result {
                case true:
                    print("updated")
                    self.myActivityIndicator.stopAnimating()
                    self.saveSuccessful()
                case false:
                    print("false")
                }
            }
        } else {
            MenuController.shared.createMenuWith(uid: self.uid, name: name, detail: detail, courseType: self.courseType, menuType: self.menuType, image: image) { (result) in
                switch result {
                case true:
                    print("saved")
                    self.myActivityIndicator.stopAnimating()
                    self.saveSuccessful()
                case false:
                    print("failed to save")
                }
            }
        }
    }
    
    @objc func handleDeleteMenu() {
        guard let menuId = menu?.id,
        let imageId = menu?.imageId else { return }
        self.myActivityIndicator.startAnimating()
        MenuController.shared.deleteMenuWith(uid: uid, menuId: menuId, imageId: imageId) { (result) in
            switch result {
            case true:
                print("deleted")
                self.myActivityIndicator.stopAnimating()
                self.deleteSuccessful()
            case false:
                print("error in delete menu")
            }
        }
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Views
    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 5
        return view
    }()
    
    var menuLabel: UILabel = {
        let label = UILabel()
        label.text = "Add a menu"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .gray
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleDeleteMenu), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        view.layer.borderWidth = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let menuImageView: CustomImageView = {
        let image = CustomImageView()
        image.image = UIImage(named: "image_background")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        image.layer.cornerRadius = 10
        image.backgroundColor = UIColor.orangeColor()
        return image
    }()
    
    let menuAddImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add an image", for: .normal)
        button.addTarget(self, action: #selector(handleAddImage), for: .touchUpInside)
        return button
    }()

    
    let dishNameTextField: UITextField = {
        let text = UITextField()
        text.textColor = .darkGray
        text.attributedPlaceholder = NSAttributedString(string: " Enter dish name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        text.layer.cornerRadius = 10
        text.backgroundColor = .white
        return text
    }()
    
    let dishDetailTextField: UITextView = {
        let text = UITextView()
        text.placeholder = "Enter dish details"
        text.backgroundColor = .white
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.layer.cornerRadius = 10
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        return text
    }()
    
    let courseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let courseLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a course"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let courseSegmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Appetizer", "Main", "Dessert"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = UIColor.orangeColor()
        seg.tintColor = UIColor.white
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        seg.addTarget(self, action: #selector(handleCourseType), for: .valueChanged)
        return seg
    }()
    
    let fixedView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fixedLabel: UILabel = {
        let label = UILabel()
        label.text = "Is this a fixed menu?"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let fixedSegmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Fixed Menu", "Sample Menu"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = UIColor.orangeColor()
        seg.tintColor = UIColor.white
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        seg.addTarget(self, action: #selector(handleMenuType), for: .valueChanged)
        return seg
    }()
}

//MARK: - Image Picker
extension AddMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            menuImagePicker.sourceType = .camera
            menuImagePicker.allowsEditing = false
            self.present(menuImagePicker, animated: true)
        } else {
            let alertVC = UIAlertController(title: "No Camera Acccess", message: "Please allow access to the camera to use this feature", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true)
        }
    }

    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            menuImagePicker.sourceType = .photoLibrary
            menuImagePicker.allowsEditing = true
            self.present(menuImagePicker, animated: true)
        } else {
            let alertVC = UIAlertController(title: "No Photo Acccess", message: "Please allow access to Photos to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.menuImageView.image = pickedImage
        }
        
        picker.dismiss(animated: true)
    }
}
