//
//  NewReviewViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/17/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NewReviewViewController: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var userId: String?
    var uid = Auth.auth().currentUser?.uid
    var review: Review?
    var user: User?
    
    // MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    // MARK: - Helper Functions
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let image = user.profileImageUrl else { return }
            self.userProfileImageView.loadImage(urlString: image)
            self.usernameLabel.text = user.username
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(userProfileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(reviewField)
        view.addSubview(ratingLabel)
        view.addSubview(ratingView)
        view.addSubview(submitButton)
        view.addSubview(myActivityIndicator)
    }
    
    func constrainViews() {
        view.anchor(top: safeArea.topAnchor, left: nil, bottom: safeArea.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width + 150)
        view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.layer.cornerRadius = 10
        userProfileImageView.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        userProfileImageView.layer.cornerRadius = 75
        userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.anchor(top: userProfileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        reviewField.anchor(top: usernameLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, height: 200)
        ratingLabel.anchor(top: reviewField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 10, height: 45)
        ratingView.anchor(top: reviewField.bottomAnchor, left: ratingLabel.rightAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, height: 35)
        submitButton.anchor(top: ratingView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, height: 45)
        
        myActivityIndicator.center = view.center
        
    }
    
    func handleDone() {
        let alertVC = UIAlertController(title: "Success", message: "Your review has been submitted", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool Beans", style: .default) { (_) in
            self.myActivityIndicator.stopAnimating()
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    //MARK: - API
    @objc func didSubmit() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        guard let reviewText = reviewField.text,
              let profileUserUid = userId else { return }
        let liveRate = self.ratingView.rating
        myActivityIndicator.startAnimating()
        UserController.shared.fetchUserWithUID(uid: currentUserUid) { (user) in
            guard let username = user.username else { return }
            ReviewController.shared.createReviewWith(currentUserUid: currentUserUid, reviewedUserUid: profileUserUid, review: reviewText, liveRate: liveRate, username: username) { (result) in
                switch result {
                case true:
                    self.handleDone()
                case false:
                    print("failed to save")
                }
            }
        }
       
    }
    
    // MARK: - Views
    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .gray
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    var reviewField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.LightGrayBg()
        textView.textColor = UIColor.darkGray
        textView.layer.cornerRadius = 5
        textView.placeholder = "Enter your review..."
        return textView
    }()
    
    let ratingView: RatingView = {
        let view = RatingView()
//        view.backgroundColor = .white
        view.minRating = 0
        view.maxRating = 5
        view.rating = 0
        view.editable = true
        view.emptyImage = UIImage(systemName: "star")
        view.fullImage = UIImage(systemName: "star.fill")
        view.tintColor = UIColor.orangeColor()
        return view
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a rating"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        return label
    }()
    
    var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = UIColor.orangeColor()
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(didSubmit), for: .touchUpInside)
        return button
    }()
}
