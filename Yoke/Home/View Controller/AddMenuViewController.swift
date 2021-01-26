//
//  AddMenuViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class AddMenuViewController: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let profileImagePicker = UIImagePickerController()
    var user: User? {
        didSet {
            
            
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

    }
 
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(swipeIndicator)
        view.addSubview(menuLabel)
        view.addSubview(menuImageView)
        view.addSubview(menuAddImageButton)
        view.addSubview(dishNameTextField)
        view.addSubview(dishDetailTextField)
        view.addSubview(courseLabel)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        menuLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuImageView.anchor(top: menuLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: view.frame.width / 2)
        menuAddImageButton.anchor(top: menuLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: view.frame.width / 2)
        dishNameTextField.anchor(top: menuImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 45)
        dishDetailTextField.anchor(top: dishNameTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 150)
        courseLabel.anchor(top: dishDetailTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 45)
    }
    
    @objc func handleAddImage() {
        print("tapped")
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    let menuImageView: CustomImageView = {
        let image = CustomImageView()
        image.image = UIImage(named: "image_background")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        image.layer.cornerRadius = 5
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
        text.layer.cornerRadius = 5
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
        text.layer.cornerRadius = 5
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        return text
    }()
    
    let courseLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a course"
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

}
