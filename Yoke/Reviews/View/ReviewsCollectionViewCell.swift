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
              let uid = review.uid else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.justified
        if case review.review = "" {
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            attributedText.append(NSAttributedString(string: " " + "There is no review to accompany this rating.", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-BookOblique", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.paragraphStyle: paragraphStyle]))
            textView.attributedText = attributedText
        } else {
            let attributedText = NSMutableAttributedString(string: username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            attributedText.append(NSAttributedString(string: " " + reviewText, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.paragraphStyle: paragraphStyle]))
            textView.attributedText = attributedText
        }
        
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let image = user.profileImageUrl else { return }
            self.profileImageView.loadImage(urlString: image)
        }
        
        guard let rating = review.stars else { return }
        self.ratingView.rating = rating
        timestampLabel.text = review.timestamp.timeAgoDisplay()
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(profileImageView)
        addSubview(timestampLabel)
        addSubview(textView)
        addSubview(ratingView)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        
        profileImageView.anchor(top: cellBackgroundView.topAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 74, height: 75)
        profileImageView.layer.cornerRadius = 75 / 2
        
        timestampLabel.anchor(top: cellBackgroundView.topAnchor, left: nil, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10)
    
        textView.anchor(top: timestampLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: -5, paddingLeft: 5, paddingBottom: 0, paddingRight: 10)

        ratingView.anchor(top: textView.bottomAnchor, left: textView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 25, width: 80, height: 40)
    }
    
    //MARK: - Views
    let cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "image_background")
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
