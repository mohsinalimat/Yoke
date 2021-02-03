//
//  HomeHeaderCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol HomeProfileHeaderDelegate {
    func viewReviews(user: User)
    func viewEvents(user: User)
    func addPhotos(user: User)
    func viewBookmarked(user: User)
    func viewCalendar(user: User)
    func viewProfile(user: User)
}

class HomeHeaderCell: UICollectionViewCell {
    
    var delegate: HomeProfileHeaderDelegate?
    let imageStorageRef = Storage.storage().reference()
    
    var user: User? {
        didSet {
            guard let user = user else {return}
            
            if let uid = user.uid {
                self.imageStorageRef.child("profileImageUrl/\(uid)").downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let imageUrl = url?.absoluteString else { return }
                    if let url = URL(string: imageUrl) {
                        let placeholder = UIImage(named: "image_background")
                        self.profileImageView.kf.indicatorType = .activity
                        let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                        self.profileImageView.kf.setImage(with: url, placeholder: placeholder, options: options)
                    }
                }
            }
            
//            let profileImageUrl = user.profileImageUrl
//            if let url = URL(string: profileImageUrl) {
//                let placeholder = UIImage(named: "image_background")
//                profileImageView.kf.indicatorType = .activity
//                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
//                profileImageView.kf.setImage(with: url, placeholder: placeholder, options: options)
//            }
            
//            let coverImageUrl = user.ProfileCoverUrl
            
//            if coverImageUrl == "" {
//                coverImageView.image = UIImage(named: "placeholder")!
//            } else {
//                coverImageView.loadImage(urlString: coverImageUrl)
//            }
            
            guard let username = user.username else { return }
            usernameLabel.text = "Hi \(username)"
            handleRatingView()
            checkIfChef()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        addSubview(coverImageView)
        addSubview(bannerImageCover)
        addSubview(profileImageView)
        addSubview(viewProfileButton)
        addSubview(usernameLabel)
    }
    
    func setupConstraints() {
        bannerImageCover.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: -50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 330)
        
        coverImageView.anchor(top: bannerImageCover.topAnchor, left: bannerImageCover.leftAnchor, bottom: bannerImageCover.bottomAnchor, right: bannerImageCover.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        profileImageView.anchor(top: coverImageView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 140, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 50
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)

        viewProfileButton.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 45)
//
        setupBottomToolbar()
    }
    
    fileprivate func setupBottomToolbar() {
        reviewsButton.alignImageTextVertical()
        EventButton.alignImageTextVertical()
        bookmarkButton.alignImageTextVertical()
        addPhotosButton.alignImageTextVertical()
        calendarButton.alignImageTextVertical()

        let stackView = UIStackView(arrangedSubviews: [reviewsButton, EventButton, addPhotosButton, bookmarkButton, calendarButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        addSubview(stackView)
        stackView.anchor(top: viewProfileButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 75)
        
        addSubview(galleryLabel)
        galleryLabel.anchor(top: stackView.bottomAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height:45)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions

    func checkIfChef() {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Users).child(uid!)
        ref.observe(.value) { (snapshot) in
            let dictionary = snapshot.value as? [String: AnyObject]
            let isChef = dictionary?[Constants.IsChef] as? Bool
            
            if isChef == true {
                self.EventButton.isHidden = false
            } else {
                self.EventButton.isHidden = true
            }

        }
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
    
    @objc func handleReviews() {
        guard let user = user else {return}
        delegate?.viewReviews(user: user)
    }
    
    @objc func handleEvents() {
        guard let user = user else {return}
        delegate?.viewEvents(user: user)
    }
    
    @objc func handleCalendar() {
        guard let user = user else {return}
        delegate?.viewCalendar(user: user)
    }
    
    @objc func handleBookmarked() {
        guard let user = user else {return}
        delegate?.viewBookmarked(user: user)
    }
    
    @objc func handleAddPhotos() {
        guard let user = user else {return}
        delegate?.addPhotos(user: user)
    }
    
    @objc func handleViewProfile() {
        guard let user = user else {return}
        delegate?.viewProfile(user: user)
    }
    
    //MARK: - Views
    let coverImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "foodBackground")
        return image
    }()
    
    let bannerImageCover: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.opacity = 0.4
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 2
        image.backgroundColor = .green
        return image
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
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
    
    lazy var viewProfileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("View Profile", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleViewProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var reviewsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "reviews"), for: .normal)
        button.setTitle("Reviews", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 45,bottom: 20,right: 0)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 20,left: -25,bottom: 0,right: 0)
        button.addTarget(self, action: #selector(handleReviews), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    lazy var EventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "event_full"), for: .normal)
        button.setTitle("Events", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleEvents), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    lazy var calendarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "calendar"), for: .normal)
        button.setTitle("Calendar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleCalendar), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bookmark_selected"), for: .normal)
        button.setTitle("Bookmarked", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleBookmarked), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    lazy var addPhotosButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add_image"), for: .normal)
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleAddPhotos), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    let galleryLabel: UILabel = {
        let label = UILabel()
        label.text = "GALLERY"
//        label.backgroundColor = UIColor.orangeColor()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor.orangeColor()
        label.backgroundColor = .white
        return label
    }()
}