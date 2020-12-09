//
//  ReviewsCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class ReviewsCell: UICollectionViewCell {
    
    var user: User?
    var review: Review? {
        didSet {
            guard let review = review else { return }
            
            if case review.text = "" {
                let attributedText = NSMutableAttributedString(string: review.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black])
                attributedText.append(NSAttributedString(string: " " + "There is no review to accompany this rating.", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-BookOblique", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.black]))
                textView.attributedText = attributedText
            } else {
                let attributedText = NSMutableAttributedString(string: review.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black])
                attributedText.append(NSAttributedString(string: " " + review.text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.black]))
                textView.attributedText = attributedText
            }
            
            timeLabel.text = review.creationDate?.timeAgoDisplay()
            profileImageView.loadImage(urlString: review.user.profileImageUrl)
            
            self.ratingView.rating = review.ratings
        }
    }

    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.white
        textView.textColor = UIColor.black
        textView.textAlignment = .justified
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let timeLabel: UILabel = {
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
        view.emptyImage = UIImage(named: "star_unselected_color")
        view.fullImage = UIImage(named: "star_selected_color")
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(textView)
        addSubview(timeLabel)
        addSubview(ratingView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileImageView.layer.cornerRadius = 40 / 2
    
        textView.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 25, width: 0, height: 0)
        
        timeLabel.anchor(top: textView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 25, width: 0, height: 0)
        
        ratingView.anchor(top: textView.bottomAnchor, left: textView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 25, width: 80, height: 40)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
