//
//  SuggestedChefsCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseStorage
import Kingfisher
import FirebaseAuth

class SuggestedChefsCollectionViewCell: UICollectionViewCell {

    var chef: User? {
        didSet {
            guard let chef = chef else { return }
            nameLabel.text = chef.username
            guard let city = chef.city, let state = chef.state else { return }
            locationLabel.text = "\(city), \(state)"
            if let uid = chef.uid {
                Storage.storage().reference().child("profileImageUrl/\(uid)").downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    guard let imageUrl = url?.absoluteString else { return }
                    if let url = URL(string: imageUrl) {
                        let placeholder = UIImage(named: "image_background")
                        self.profileImage.kf.indicatorType = .activity
                        let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                        self.profileImage.kf.setImage(with: url, placeholder: placeholder, options: options)
                    }
                }
            }
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
        addSubview(locationLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        profileImage.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 120, height: 120)
        profileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.anchor(top: profileImage.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        locationLabel.anchor(top: nameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
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
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    let cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
}
