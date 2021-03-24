//
//  EventCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/22/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    var event: Event? {
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
    
    //MARK: - Helper Funtions
    func configure() {
        guard let event = event,
              let uid = event.uid else { return }
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let image = user.profileImageUrl else { return }
            self.profileImage.loadImage(urlString: image)
            self.usernameLabel.text = user.username
        }
        guard let eventImg = event.eventImageUrl else { return }
        print("event image url \(eventImg)")
        eventImage.loadImage(urlString: eventImg)
        captionLabel.text = event.caption
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(eventImage)
        addSubview(captionLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        profileImage.anchor(top: cellBackgroundView.topAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        usernameLabel.anchor(top: cellBackgroundView.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        eventImage.anchor(top: profileImage.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: frame.width / 2)
        captionLabel.anchor(top: eventImage.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
    }
    
    //MARK: Views
    var profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var eventImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        return image
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
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
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
}
