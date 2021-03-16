//
//  ReviewsCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/18/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    
    var user: User?
    var review: Review? {
        didSet {
            configure()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configure() {
        guard let review = review else { return }
        guard let username = review.username,
              let reviewText = review.review,
              let uid = review.uid,
              let date = review.timestamp else { return }
        if case review.review = "" {
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            attributedText.append(NSAttributedString(string: " " + "There is no review to accompany this rating.", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-BookOblique", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
            textView.attributedText = attributedText
        } else {
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            attributedText.append(NSAttributedString(string: " " + reviewText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.darkGray ]))
            textView.attributedText = attributedText
        }
        
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let image = user.profileImageUrl else { return }
            self.profileImageView.loadImage(urlString: image)
        }
        
        guard let rating = review.stars else { return }
        self.ratingView.rating = rating
        timestampLabel.text = date
    }
    
    func setupViews() {
        addSubview(profileImageView)
        addSubview(textView)
        addSubview(timestampLabel)
        addSubview(ratingView)
        addSubview(seperatorView)
    }
    
    func setupConstraints() {
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 74, height: 75)
        profileImageView.layer.cornerRadius = 75 / 2
    
        textView.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        
        timestampLabel.anchor(top: textView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 25)

        ratingView.anchor(top: textView.bottomAnchor, left: textView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 25, width: 80, height: 40)
        
        seperatorView.anchor(top: ratingView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, height: 0.5)
    }
    
    //MARK: - Views
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .white
        textView.textAlignment = .justified
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.backgroundColor = .green
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.backgroundColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ratingView: RatingView = {
        let view = RatingView()
        view.backgroundColor = .clear
        view.minRating = 0
        view.maxRating = 5
        view.rating = 0
        view.editable = false
        view.emptyImage = UIImage(systemName: "star")
        view.fullImage = UIImage(systemName: "star.fill")
        view.tintColor = UIColor.orangeColor()
        return view
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        return view
    }()
}
