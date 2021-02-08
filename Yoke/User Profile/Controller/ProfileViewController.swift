//
//  ProfileViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/8/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ProfileViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var userId: String?
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
        fetchUser()
    }
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username,
                  let city = user.city,
                  let state = user.state else { return }
            self.usernameLabel.text = username
            self.locationLabel.text = "\(city), \(state)"
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
    }
    
    func setupButtonImages() {
        reviewsButton.alignImageTextVertical()
        eventButton.alignImageTextVertical()
        bookmarkButton.alignImageTextVertical()
        addPhotosButton.alignImageTextVertical()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(scrollView)
        scrollView.addSubview(bannerImageView)
        scrollView.addSubview(bannerLayerImageView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(ratingView)
        scrollView.addSubview(statsStackView)
        statsStackView.addArrangedSubview(reviewCountLabel)
        statsStackView.addArrangedSubview(rebookCountLabel)
        statsStackView.addArrangedSubview(verifiedLabel)
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(reviewsButton)
        buttonStackView.addArrangedSubview(eventButton)
        buttonStackView.addArrangedSubview(addPhotosButton)
        buttonStackView.addArrangedSubview(bookmarkButton)
    }
    
    func constrainViews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - 200)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: -100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        bannerLayerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: -100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 250)

        bannerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: -100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 250)
        
        profileImageView.anchor(top: bannerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        profileImageView.layer.cornerRadius = 75
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        locationLabel.anchor(top: usernameLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        ratingView.anchor(top: locationLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        statsStackView.anchor(top: ratingView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 35)
        setupButtonImages()
        buttonStackView.anchor(top: statsStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 60)
        
    }

    //MARK: - Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bannerImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .white
        image.image = UIImage(named: "image_background")
        return image
    }()
    
    let bannerLayerImageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.opacity = 0.1
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.image = UIImage(named: "person.crop.circle.fill")
        image.tintColor = UIColor.orangeColor()
        image.backgroundColor = .white
        image.layer.borderWidth = 2
        return image
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    let ratingView: RatingView = {
        let view = RatingView()
        view.backgroundColor = .clear
        view.minRating = 0
        view.maxRating = 5
        view.rating = 2.5
        view.editable = false
        view.emptyImage = UIImage(named: "star_unselected_color")
        view.fullImage = UIImage(named: "star_selected_color")
        return view
    }()
    
    let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.backgroundColor = .gray
        return stackView
    }()

    let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.text = "55 reviews"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let rebookCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "7 rebooks"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let verifiedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Verified Chef"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        return stackView
    }()
    
    lazy var reviewsButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "reviews"), for: .normal)
        let image = UIImage(named: "reviews")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Reviews", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 45,bottom: 20,right: 0)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 20,left: -25,bottom: 0,right: 0)
//        button.addTarget(self, action: #selector(handleReviews), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var eventButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "event_full"), for: .normal)
        let image = UIImage(named: "event_full")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Events", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.addTarget(self, action: #selector(handleEvents), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "bookmark_selected"), for: .normal)
        let image = UIImage(named: "bookmark_selected")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Bookmarked", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.addTarget(self, action: #selector(handleBookmarked), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var addPhotosButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "add_image"), for: .normal)
        let image = UIImage(named: "add_image")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.addTarget(self, action: #selector(handleAddPhotos), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
}
