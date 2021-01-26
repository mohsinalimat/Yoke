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
        view.addSubview(scrollView)
        scrollView.addSubview(menuImageView)
        scrollView.addSubview(menuAddImageButton)
        scrollView.addSubview(dishNameTextField)
        scrollView.addSubview(dishDetailTextField)
        scrollView.addSubview(courseView)
        scrollView.addSubview(courseLabel)
        scrollView.addSubview(courseSegmentedControl)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        menuLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.anchor(top: menuLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        menuImageView.anchor(top: menuLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: view.frame.width / 2)
        menuAddImageButton.anchor(top: menuLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: view.frame.width / 2)
        dishNameTextField.anchor(top: menuImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 45)
        dishDetailTextField.anchor(top: dishNameTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 150)
        courseView.anchor(top: dishDetailTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 95)
        courseLabel.anchor(top: courseView.topAnchor, left: courseView.leftAnchor, bottom: nil, right: courseView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, height: 45)
        courseSegmentedControl.anchor(top: courseLabel.bottomAnchor, left: courseView.leftAnchor, bottom: nil, right: courseView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 45)
    }
 
    @objc func handleAddImage() {
        print("tapped")
    }
    
    @objc func handleCourseType(index: Int) {
        if courseSegmentedControl.selectedSegmentIndex == 0 {
            print("app")
        } else if courseSegmentedControl.selectedSegmentIndex == 1 {
            print("main")
        } else if courseSegmentedControl.selectedSegmentIndex == 2 {
            print("dessert")
        }
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
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.cornerRadius = 5
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
    
    let courseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
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
        let seg = UISegmentedControl(items: ["Appetizer,", "Main", "Dessert"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = UIColor.orangeColor()
        seg.tintColor = UIColor.white
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        seg.addTarget(self, action: #selector(handleCourseType), for: .valueChanged)
        return seg
    }()

}
