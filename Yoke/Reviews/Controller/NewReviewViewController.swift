//
//  NewReviewViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/17/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewReviewViewController: UIViewController {
    
    //MARK: - Properties
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
            print("crazy \(user.uid)")
        }
    }
    
    func setupViews() {
        view.addSubview(userProfileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(reviewField)
        view.addSubview(ratingLabel)
        view.addSubview(ratingView)
        view.addSubview(submitButton)
    }
    
    func constrainViews() {
        
    }
    
    @objc func didSubmit() {
        
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
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    var reviewField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textColor = UIColor.darkGray
        textView.layer.cornerRadius = 5
        textView.placeholder = "Enter your review..."
        return textView
    }()
    
    let ratingView: RatingView = {
        let view = RatingView()
        view.backgroundColor = .clear
        view.minRating = 0
        view.maxRating = 5
        view.rating = 0
        view.editable = true
        view.emptyImage = UIImage(named: "star_unselected_color")
        view.fullImage = UIImage(named: "star_selected_color")
        return view
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a rating"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.textAlignment = .center
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
