//
//  SuggestedChefsCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class SuggestedChefsCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties
    let firestoreDB = Firestore.firestore()
    var chef: User? {
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
        guard let chef = chef else { return }
        guard let uid = chef.uid else { return }
        nameLabel.text = chef.username
        guard let city = chef.city, let state = chef.state else { return }
        locationLabel.text = "\(city), \(state)"
        guard let image = chef.profileImageUrl else { return }
        profileImage.loadImage(urlString: image)
        handleRatingView(uid: uid)
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundImage)
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(ratingView)
        addSubview(locationLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        cellBackgroundImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        profileImage.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 120, height: 120)
        profileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.anchor(top: profileImage.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ratingView.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 15)
        ratingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        locationLabel.anchor(top: ratingView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    func handleRatingView(uid: String) {
        firestoreDB.collection(Constants.Users).document(uid).collection(Constants.Ratings).getDocuments() { (querySnapshot, error) in
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
    
    //MARK: Views
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
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let ratingView: RatingView = {
        let view = RatingView()
        view.backgroundColor = .clear
        view.minRating = 0
        view.maxRating = 5
        view.rating = 2.5
        view.editable = false
        view.emptyImage = UIImage(named: "star_unselected_white")
        view.fullImage = UIImage(named: "star_selected_white")
        return view
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    let cellBackgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "image_background")
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
//        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
//        view.backgroundColor = .white
        return view
    }()
}
