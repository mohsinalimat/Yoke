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
            guard let image = user.profileImageUrl,
                  let username = user.username else { return }
            self.profileImage.loadImage(urlString: image)
            self.usernameLabel.text = "Posted by: \(username)"
        }
        guard let eventImg = event.eventImageUrl else { return }
        print("event image url \(eventImg)")
        eventImage.loadImage(urlString: eventImg)
        captionLabel.text = event.caption
        locationLabel.text = "453 12th street, Brooklyn NY"
        dateLabel.text = "July 4 2021"
        timeLabel.text = "11:00am - 5:00pm"
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(profileImage)
        addSubview(usernameLabel)
        addSubview(eventImage)
        addSubview(captionLabel)
        addSubview(locationIcon)
        addSubview(locationLabel)
        addSubview(dateIcon)
        addSubview(dateLabel)
        addSubview(timeIcon)
        addSubview(timeLabel)
        addSubview(moreIcon)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        profileImage.anchor(top: cellBackgroundView.topAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        usernameLabel.anchor(top: cellBackgroundView.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        eventImage.anchor(top: profileImage.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: frame.width / 2)
        captionLabel.anchor(top: eventImage.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        locationIcon.anchor(top: captionLabel.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 18)
        locationLabel.anchor(top: nil, left: locationIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        dateIcon.anchor(top: locationIcon.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
        timeIcon.anchor(top: dateIcon.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        timeLabel.anchor(top: timeIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        moreIcon.anchor(top: nil, left: nil, bottom: cellBackgroundView.bottomAnchor, right: cellBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 30, height: 30)
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
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
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
    
    var locationIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "locationPinOrange")
        return image
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    var dateIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "calendarOrange")
        return image
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    var timeIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeOrange")
        return image
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    var moreIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "arrow-right-circle-fill")
        return image
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
