//
//  MenuViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var uid = Auth.auth().currentUser?.uid ?? ""
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
    }
 
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(swipeIndicator)
        view.addSubview(scrollView)
        scrollView.addSubview(menuImageView)
        scrollView.addSubview(menuLabel)
        scrollView.addSubview(menuTypeLabel)
        scrollView.addSubview(dishDetailTextView)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.anchor(top: swipeIndicator.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        menuImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width)
        menuLabel.anchor(top: menuImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        menuTypeLabel.anchor(top: menuLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        dishDetailTextView.anchor(top: menuTypeLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: scrollView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 100)
    }
    
    func fetchMenu() {
        guard let image = menu?.imageUrl else { return }
        menuImageView.loadImage(urlString: image)
        menuLabel.text = menu?.name
        guard let course = menu?.courseType,
              let type = menu?.menuType else { return }
        menuTypeLabel.text = "\(course) \(type) Menu"
        dishDetailTextView.text = menu?.detail
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
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 15
        return image
    }()
    
    var menuLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .gray
        return label
    }()
    
    let dishDetailTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = UIColor.LightGrayBg()
        text.textColor = .darkGray
        text.isEditable = false
        text.isScrollEnabled = true
        text.layer.cornerRadius = 5
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 15)
        return text
    }()
    
    var menuTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()

}