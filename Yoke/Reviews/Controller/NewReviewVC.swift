//
//  NewReviewVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 4/7/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import Foundation
import Firebase

class NewReviewVC: UIViewController, FloatRatingViewDelegate {
    
    var userId: String?
    var uid = Auth.auth().currentUser?.uid
    var review: Review?
    var user: User? {
        didSet {
            guard let uid = self.user?.uid else { return }
            Database.fetchUserWithUID(uid: uid) { (user) in
                self.user = user
                self.usernameLabel.text = "Review for \(user.username)"
                self.userProfileImageView.loadImage(urlString: user.profileImageUrl)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
        setupNavTitleAndBarButtonItems()
        ratingView.delegate = self
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        ratingView.type = .wholeRatings
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Write Review"

    }
    
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
    
    var reviewField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textColor = UIColor.darkGray
        textView.layer.cornerRadius = 5
        textView.placeholder = "Enter your review..."
        return textView
    }()
    
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

    fileprivate func setupView() {
        view.addSubview(userProfileImageView)
        userProfileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        userProfileImageView.layer.cornerRadius = 50 / 2
//        userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        view.addSubview(reviewField)
        reviewField.anchor(top: userProfileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 10, paddingRight: 15, width: 0, height: 300)
        
        view.addSubview(ratingLabel)
        ratingLabel.anchor(top: reviewField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(ratingView)
        ratingView.anchor(top: reviewField.bottomAnchor, left: ratingLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 60, paddingBottom: 20, paddingRight: 15, width: 0, height: 30)
        
        view.addSubview(submitButton)
        submitButton.anchor(top: ratingLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)
    }
    
    @objc func didSubmit() {
        let userId = self.user?.uid ?? ""
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child(Constants.Reviews).child(userId).childByAutoId()
//        let checkUserRef = Database.database().reference().child(Constants.Ratings).child(userId).child(currentUserId)
        let ratingsRef = Database.database().reference().child(Constants.Ratings).child(userId)
        let reviewText = reviewField.text
        let liveRate = self.ratingView.rating
        let rateValues = [currentUserId: liveRate]
        let values = [Constants.Text: reviewText!, Constants.CreationDate: Date().timeIntervalSince1970, Constants.Uid: currentUserId, Constants.Ratings: liveRate] as [String : Any]

        let isValid = self.reviewField.text.count > 0 && liveRate >= 1

        if isValid {
            ref.updateChildValues(values)
            ratingsRef.updateChildValues(rateValues)
            self.dismiss(animated: true, completion: nil)
        } else {
            self.errorAlert()
        }

//        checkUserRef.observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.exists() {
//                if isValid {
//                    ratingsRef.updateChildValues(rateValues)
//                    ref.updateChildValues(values)
//                    self.updatedRatingAlert()
//                } else {
//                    self.ratingReviewErrorAlert()
//                }
//
//            } else {
//                print("not rated")
//                if liveRate >= 1 {
//                    ref.updateChildValues(values)
//                    ratingsRef.updateChildValues(rateValues)
////                    self.ratingAddedAlert()
//                    self.dismiss(animated: true, completion: nil)
//                } else {
//                    self.errorAlert()
//                }
//            }
//        }
//         self.dismiss(animated: true, completion: nil)
       
    }

    func ratingReviewErrorAlert() {
        let alert = UIAlertController(title: "Please try again", message: "You must enter a new star rating and explain why your rating has changed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func errorAlert() {
        let alert = UIAlertController(title: "Please try again", message: "You must enter a star rating and review to continue", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

