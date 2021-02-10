//
//  SuggestedChefsCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class SuggestedChefsCollectionViewCell: UICollectionViewCell {

    var chef: User? {
        didSet {
            guard let chef = chef else { return }
            nameLabel.text = chef.username
            guard let city = chef.city, let state = chef.state else { return }
            locationLabel.text = "\(city), \(state)"
            guard let image = chef.profileImageUrl else { return }
            profileImage.loadImage(urlString: image)
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
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(ratingView)
        addSubview(locationLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        profileImage.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 120, height: 120)
        profileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.anchor(top: profileImage.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        ratingView.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 70, height: 15)
        ratingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        locationLabel.anchor(top: ratingView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    var profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 60
//        image.layer.borderWidth = 2
//        image.layer.borderColor = UIColor.orangeColor()?.cgColor
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
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
        view.emptyImage = UIImage(named: "star_unselected_color")
        view.fullImage = UIImage(named: "star_selected_color")
        return view
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    let cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
//        view.layer.borderWidth = 0.5
//        view.layer.borderColor = UIColor.orangeColor()?.cgColor
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
}
