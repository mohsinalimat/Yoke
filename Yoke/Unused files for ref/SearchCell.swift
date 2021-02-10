
//
//  SearchCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class SearchCell: UICollectionViewCell, UISearchBarDelegate {

//    var review: Review?
    var user: User? {
        didSet {
            usernameLabel.text = user?.username
            
            if user?.location == "" {
                
            } else {
                locationLabel.text = user?.location
            }
//            locationLabel.text = user?.location
            
            let ref = Database.database().reference().child(Constants.Users).child(user?.uid ?? "").child(Constants.ChefType)
            ref.observe(.value) { (snapshot) in
                for child in snapshot.children {
                    if child as? Int == 1 {
                        print(child)
                       self.forHireLabel.text = "Hire me for your next cooking event"
                    }
//                    let snap = child as! DataSnapshot
//                    let val = snap.value as! Double
                    
                }
//                if let isSaved = snapshot.value as? Int, isSaved == 1 {
//                   print(isSaved)
//                }
//                if let isChef = snapshot.value as? Bool, isChef == true {
//                    self.forHireLabel.text = "Hire me for your next cooking event"
//                }
            }
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            
            profileImageView.loadImage(urlString: profileImageUrl)
            
//            guard let review = review else { return }
            handleRatingView()
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
    
    let profileImageView: CustomImageView = {
        let photo = CustomImageView()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 20)
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
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Somewhere in NY"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let forHireLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(ratingView)
        addSubview(locationLabel)
        addSubview(forHireLabel)
        
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 60 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        ratingView.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 60, height: 20)
        
        locationLabel.anchor(top: ratingView.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        forHireLabel.anchor(top: locationLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
