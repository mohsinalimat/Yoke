//
//  SearchTableViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/9/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SearchTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            configure()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func configure() {
        guard let user = user else { return }
        guard let city = user.city,
              let state = user.state,
              let uid = user.uid else { return }
        usernameLabel.text = user.username
        locationLabel.text = "\(city), \(state)"
        guard let image = user.profileImageUrl else { return }
        profileImage.loadImage(urlString: image)
        fetchUserAverageRating(uid: uid)
    }
    
    func setupViews(){
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(ratingView)
        addSubview(reviewCountLabel)
        addSubview(locationLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        profileImage.anchor(top: nil, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImage.layer.cornerRadius = 40
        profileImage.centerYAnchor.constraint(equalTo: cellBackgroundView.centerYAnchor).isActive = true
        usernameLabel.anchor(top: cellBackgroundView.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        ratingView.anchor(top: usernameLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 70, height: 15)
        reviewCountLabel.anchor(top: ratingView.topAnchor, left: ratingView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        locationLabel.anchor(top: ratingView.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
    }
    
    func fetchUserAverageRating(uid: String) {
        Firestore.firestore().collection(Constants.Users).document(uid).collection(Constants.Ratings).getDocuments() { (querySnapshot, error) in
            var totalCount = 0.0
            var count = 0.0
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                count = Double(querySnapshot?.count ?? 0)
                for document in querySnapshot!.documents {
                    if let rate = document.data()[Constants.Stars] as? Double {
                        totalCount += rate
                        if count <= 1 {
                            self.reviewCountLabel.text = "\(Int(count)) review"
                        } else {
                            self.reviewCountLabel.text = "\(Int(count)) reviews"
                        }
                    }
                }
            }
            let average = totalCount/count
            self.ratingView.rating = average
        }
    }
    
    //MARK: - Views
    var cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 60
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    let ratingView: RatingView = {
        let view = RatingView()
        view.backgroundColor = .clear
        view.minRating = 0
        view.maxRating = 5
        view.rating = 2.5
        view.editable = false
        view.emptyImage = UIImage(systemName: "star")
        view.fullImage = UIImage(systemName: "star.fill")
        view.tintColor = UIColor.orangeColor()
        return view
    }()
    
    let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0 reviews"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}
