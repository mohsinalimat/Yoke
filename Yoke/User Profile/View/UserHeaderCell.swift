//
//  UserHeaderCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Kingfisher

protocol UserProfileHeaderDelegate {
    func sendMessage(user: User)
    func viewReviews(user: User)
    func viewEvents(user: User)
}

class UserHeaderCell: UICollectionViewCell {
    
    let ref = Database.database().reference()
    var delegate: UserProfileHeaderDelegate?
    
    var user: User? {
        didSet {
            
            guard let user = user else {return}
            let profileImageUrl = user.profileImageUrl
//            guard let profileImageUrl = user.profileImageUrl else {return}
            if let url = URL(string: profileImageUrl) {
                let placeholder = UIImage(named: "image_background")
                profileImageView.kf.indicatorType = .activity
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                profileImageView.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
            
//            profileImageView.loadImage(urlString: profileImageUrl)
            let coverImageUrl = user.ProfileCoverUrl
            if coverImageUrl == "" {
                coverImageView.image = UIImage(named: "image_background")!
            } else {
                coverImageView.loadImage(urlString: coverImageUrl)
            }
            
            locationLabel.text = user.location
            if user.userRate! > 0 {
                rateLabel.text = "$\(user.userRate!)/hr"
            } else {
                rateLabel.text = ""
            }
            usernameLabel.text = user.username
            aboutLabel.text = user.aboutUser
            
            if user.uid == Auth.auth().currentUser?.uid {
                bookmarkButton.isHidden = true
            } else {
                bookmarkButton.isHidden = false
            }
            
            handleRatingView()
            setupBookmarkButton()
            checkIfChef()
        }
    }
    
    func checkIfChef() {
        let uid = user?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!)
        ref.observe(.value) { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            let isChef = dictionary?[Constants.IsChef] as? Bool
            
            if isChef == true {
                self.EventButton.isHidden = false
                self.messageButton.isHidden = false
                self.specialtiesLabel.isHidden = false
                self.qualificationLabel.isHidden = false
                self.s1Label.isHidden = false
                self.s2Label.isHidden = false
                self.s3Label.isHidden = false
                self.q1Label.isHidden = false
                self.q2Label.isHidden = false
                self.q3Label.isHidden = false
            } else {
                self.EventButton.isHidden = true
                self.messageButton.isHidden = true
                self.specialtiesLabel.isHidden = true
                self.qualificationLabel.isHidden = true
                self.s1Label.isHidden = true
                self.s2Label.isHidden = true
                self.s3Label.isHidden = true
                self.q1Label.isHidden = true
                self.q2Label.isHidden = true
                self.q3Label.isHidden = true
            }

        }
    }
    
    var getCurrentUser: Firebase.User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }
        
        return nil
    }
    
    @objc func handleRatingView() {
        let userId = self.user?.uid ?? ""
        Database.database().reference().child(Constants.Ratings).child(userId).observe(.value, with: { snapshot in
            let count = snapshot.childrenCount
            var total: Double = 0.0
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let val = snap.value as! Double
                total += val
            }
            let average = total/Double(count)
            self.ratingView.rating = average
        })
    }
    
    func observeBookmarkCount(withId id: String, completion: @escaping (Int, UInt) -> Void) {
        let getUid = self.user?.uid
        var bookmarkHandler: UInt!
        bookmarkHandler = Database.database().reference().child(Constants.Users).child(getUid!).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int {
                completion(value, bookmarkHandler)
            }
        })
    }
    
    func updateBookmarkCount() {
        let getUid = self.user?.uid
        let postRef = Database.database().reference().child(Constants.Users).child(getUid!)
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var user = currentData.value as? [String : AnyObject], let uid = self.getCurrentUser?.uid {
                var bookmarks: Dictionary<String, Bool>
                bookmarks = user[Constants.Bookmarks] as? [String : Bool] ?? [:]
                var bookmarkCount = user[Constants.BookmarkCount] as? Int ?? 0
                if let _ = bookmarks[uid] {
                    bookmarkCount -= 1
                    bookmarks.removeValue(forKey: uid)
                } else {
                    bookmarkCount += 1
                    bookmarks[uid] = true
                }
                user[Constants.BookmarkCount] = bookmarkCount as AnyObject?
                user[Constants.Bookmarks] = bookmarks as AnyObject?
                currentData.value = user
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error)
            }
        }
        ref.removeAllObservers()
        handleBookmarked()
    }
    
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    @objc func handleBookmarked() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        let ref = Database.database().reference().child(Constants.BookmarkedUsers).child(currentUserId)
        let values = [userId: 1]
        
        if bookmarkButton.isSelected {
            ref.child(userId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("failed to un-save", err)
                    return
                }
                NotificationCenter.default.post(name: UserHeaderCell.updateNotificationName, object: nil)
            })
        } else {
            ref.updateChildValues((values)) { (err, ref) in
                if let err = err {
                    print("failed to save user", err)
                    return
                }
                NotificationCenter.default.post(name: UserHeaderCell.updateNotificationName, object: nil)
            }
        }
        ref.removeAllObservers()
    }
    
    func setupBookmarkButton() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        Database.database().reference().child(Constants.BookmarkedUsers).child(currentUserId).child(userId).observe(.value, with: { (snapshot) in
            if let isSaved = snapshot.value as? Int, isSaved == 1 {
                self.bookmarkButton.isSelected = true
                self.bookmarkButton.setImage(UIImage(named: "bookmark_selected"), for: .normal)
                self.bookmarkButton.setTitle("Bookmarked", for: .normal)
            } else {
                self.bookmarkButton.isSelected = false
                self.bookmarkButton.setImage(UIImage(named: "bookmark_unselected"), for: .normal)
                self.bookmarkButton.setTitle("Bookmark", for: .normal)
            }
        }) { (err) in
            print("failed to check saved", err)
        }
    }
    
    let coverImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        //        image.layer.opacity = 0.4
        return image
    }()
    
    let bannerImageCover: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.4
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        return image
    }()
    
    lazy var reviewsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "reviews"), for: .normal)
        button.setTitle("Reviews", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
//        button.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 45,bottom: 20,right: 0)
//        button.titleEdgeInsets = UIEdgeInsets.init(top: 20,left: -25,bottom: 0,right: 0)
        button.addTarget(self, action: #selector(handleReviews), for: .touchUpInside)
        return button
    }()
    
    @objc func handleReviews() {
        guard let user = user else {return}
        delegate?.viewReviews(user: user)
    }
    
    lazy var EventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "event_full"), for: .normal)
        button.setTitle("Events", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleEvents), for: .touchUpInside)
        return button
    }()
    
    @objc func handleEvents() {
        guard let user = user else {return}
        delegate?.viewEvents(user: user)
    }
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "message_full"), for: .normal)
        button.setTitle("Request Booking", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
//        button.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 25,bottom: 20,right: 0)
//        button.titleEdgeInsets = UIEdgeInsets.init(top: 20,left: -25,bottom: 0,right: 0)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSendMessage() {
        guard let user = user else { return }
        reviewsButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.sendMessage(user: user)
    }
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "save_unselectedSalmon"), for: .normal)
//        button.setTitle("Bookmarked", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 30,bottom: 20,right: 0)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 30,left: -30,bottom: 0,right: 5)
        button.addTarget(self, action: #selector(handleBookmarked), for: .touchUpInside)
        return button
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
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let qualificationLabel: UILabel = {
        let label = UILabel()
        label.text = "Qualifications:"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let q1Label: UILabel = {
        let label = UILabel()
        label.text = "Professional Chef"
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let q2Label: UILabel = {
        let label = UILabel()
        label.text = "Safe Food Certified"
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let q3Label: UILabel = {
        let label = UILabel()
        label.text = "Background Check"
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let specialtiesLabel: UILabel = {
        let label = UILabel()
        label.text = "Specialties:"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let s1Label: UILabel = {
        let label = UILabel()
        label.text = "Classic French"
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let s2Label: UILabel = {
        let label = UILabel()
        label.text = "Seafood"
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let s3Label: UILabel = {
        let label = UILabel()
        label.text = "BBQ"
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.textAlignment = .justified
        return label
    }()
    
    let bookmarkedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    let galleryLabel: UILabel = {
        let label = UILabel()
        label.text = "GALLERY"
        label.backgroundColor = UIColor.orangeColor()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(coverImageView)
        addSubview(bannerImageCover)
        addSubview(profileImageView)
        addSubview(ratingView)
        addSubview(usernameLabel)
        addSubview(aboutLabel)
        
        bannerImageCover.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: -50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 250)
        
        coverImageView.anchor(top: bannerImageCover.topAnchor, left: bannerImageCover.leftAnchor, bottom: bannerImageCover.bottomAnchor, right: bannerImageCover.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        profileImageView.anchor(top: coverImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: -60, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        profileImageView.layer.cornerRadius = 60
        
        usernameLabel.anchor(top: coverImageView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: -25, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        ratingView.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        
        let locationRateView = UIStackView(arrangedSubviews: [locationLabel, rateLabel])
        locationRateView.axis = .vertical
        locationRateView.distribution = .fillProportionally
        locationRateView.spacing = 0
        addSubview(locationRateView)
        locationRateView.anchor(top: ratingView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        aboutLabel.anchor(top: locationRateView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        let qualificationView = UIStackView(arrangedSubviews: [qualificationLabel, q1Label, q2Label, q3Label])
        qualificationView.axis = .vertical
        qualificationView.distribution = .fill
        qualificationView.spacing = 1
        addSubview(qualificationView)
        qualificationView.anchor(top: aboutLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let specialtiesView = UIStackView(arrangedSubviews: [specialtiesLabel, s1Label, s2Label, s3Label])
        specialtiesView.axis = .vertical
        specialtiesView.distribution = .fill
        specialtiesView.spacing = 1
        addSubview(specialtiesView)
        specialtiesView.anchor(top: qualificationLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        messageButton.alignImageTextVertical()
        reviewsButton.alignImageTextVertical()
        EventButton.alignImageTextVertical()
        bookmarkButton.alignImageTextVertical()
        
        let stackView = UIStackView(arrangedSubviews: [reviewsButton, EventButton, messageButton, bookmarkButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        addSubview(stackView)
        stackView.anchor(top: qualificationView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 75)
        
        addSubview(galleryLabel)
        galleryLabel.anchor(top: stackView.bottomAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 30)
        
//        setupBottomToolbar()
    }
    
//    fileprivate func setupBottomToolbar() {
//
//        messageButton.alignImageTextVertical()
//        reviewsButton.alignImageTextVertical()
//        EventButton.alignImageTextVertical()
//        bookmarkButton.alignImageTextVertical()
//
//        let stackView = UIStackView(arrangedSubviews: [reviewsButton, EventButton, messageButton, bookmarkButton])
//
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.spacing = 0
//        addSubview(stackView)
//        stackView.anchor(top: qualificationView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 75)
//
//        addSubview(galleryLabel)
//        galleryLabel.anchor(top: stackView.bottomAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: 30)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

