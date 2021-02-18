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
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setupViews(){
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(ratingView)
        addSubview(reviewCountLabel)
        addSubview(locationLabel)
    }
    
    func setupConstraints() {
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImage.layer.cornerRadius = 40
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameLabel.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        ratingView.anchor(top: usernameLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 70, height: 15)
        reviewCountLabel.anchor(top: ratingView.topAnchor, left: ratingView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        locationLabel.anchor(top: ratingView.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
    }
    
    func fetchUserAverageRating(uid: String) {
        Firestore.firestore().collection(Constants.Users).document(uid).collection(Constants.Ratings).getDocuments() { (querySnapshot, error) in
            var totalCount = 0.0
            var count = 0.0
            if error != nil {
                print(error?.localizedDescription)
            } else {
                count = Double(querySnapshot?.count ?? 0)
                for document in querySnapshot!.documents {
                    if let rate = document.data()[Constants.Stars] as? Double {
                        totalCount += rate
                    }
                }
            }
            let average = totalCount/count
            self.ratingView.rating = average
        }
    }
    
    //MARK: - Views
    var profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 60
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        view.emptyImage = UIImage(named: "star_unselected_color")
        view.fullImage = UIImage(named: "star_selected_color")
        return view
    }()
    
    let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.text = "12 reviews"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}
