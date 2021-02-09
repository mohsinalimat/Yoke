//
//  SearchTableViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/9/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class SearchTableViewCell: UITableViewCell {

    var user: User? {
        didSet {
            guard let user = user else { return }
            usernameLabel.text = user.username
            locationLabel.text = user.location
            guard let image = user.profileImageUrl else { return }
            profileImage.loadImage(urlString: image)
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
        addSubview(locationLabel)
    }
    
    func setupConstraints() {
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImage.layer.cornerRadius = 50/2
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameLabel.anchor(top: profileImage.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
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
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        return label
    }()

}
