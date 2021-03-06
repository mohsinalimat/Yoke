//
//  TodayCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/5/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class TodayCollectionViewCell: UICollectionViewCell {
    
    var booking: Booking? {
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
        guard let booking = booking,
        let uid = booking.userUid else { return }
        UserController.shared.fetchUserWithUID(uid: uid) { user in
            guard let image = user.profileImageUrl else { return }
            self.profileImage.loadImage(urlString: image)
            self.nameLabel.text = user.username
        }
        locationLabel.text = booking.locationShort
        dateLabel.text = booking.date
        guard let start = booking.startTime,
              let end = booking.endTime else { return }
        timeLabel.text = "\(start) - \(end)"
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundImage)
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(locationIcon)
        addSubview(locationLabel)
        addSubview(dateIcon)
        addSubview(dateLabel)
        addSubview(timeIcon)
        addSubview(timeLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        cellBackgroundImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        profileImage.anchor(top: shadowView.topAnchor, left: shadowView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        nameLabel.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 10)
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        locationIcon.anchor(top: nameLabel.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 18)
        locationLabel.anchor(top: nil, left: locationIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 10)
        locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        dateIcon.anchor(top: locationIcon.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 10)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
        timeIcon.anchor(top: dateIcon.bottomAnchor, left: nameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        timeLabel.anchor(top: timeIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 10)
        timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        
    }
    
    var profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "gradientBackgroundHalf")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Usernamex"
        label.textColor = UIColor.white
        return label
    }()
    
    var locationIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "location-pin-white")
        return image
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "453 12th Street, Brooklyn NY"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    var dateIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "calendarWhite")
        return image
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Friday, Apr 16, 2021"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    var timeIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeWhite")
        return image
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "5:00 PM - 8:00 PM"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    let cellBackgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "gradientBackgroundHalf")
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = UIColor.gray.cgColor
        return view
    }()
}
