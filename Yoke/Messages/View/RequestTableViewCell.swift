//
//  RequestTableViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/10/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class RequestTableViewCell: UITableViewCell {

    //MARK: - Properties
    var booking: Booking? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Lifecycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    //MARK: - Helper Functions
    func configure() {
        guard let booking = booking else { return }
        if booking.chefUid == Auth.auth().currentUser?.uid ?? "" {
            guard let uid = booking.userUid else { return }
            UserController.shared.fetchUserWithUID(uid: uid) { (user) in
                guard let name = user.username else { return }
                self.nameLabel.text = "\(name) has requested a booking"
            }
        } else {
            guard let uid = booking.chefUid else { return }
            UserController.shared.fetchUserWithUID(uid: uid) { (user) in
                guard let name = user.username else { return }
                self.nameLabel.text = "You sent a request to \(name)"
            }
        }
        timestampLabel.text = booking.timestamp.timeAgoDisplay()
        dateLabel.text = booking.date
    }

    func setupViews() {
        addSubview(shadowView)
//        addSubview(profileImage)
        addSubview(timestampLabel)
        addSubview(nameLabel)
        addSubview(dateIcon)
        addSubview(dateLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
//        profileImage.anchor(top: nil, left: shadowView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 75, height: 75)
//        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timestampLabel.anchor(top: shadowView.topAnchor, left: nil, bottom: nil, right: shadowView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5)
        nameLabel.anchor(top: timestampLabel.bottomAnchor, left: shadowView.leftAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        dateIcon.anchor(top: nameLabel.bottomAnchor, left: shadowView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 10)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
    }
    
    //MARK: - Views
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 75 / 2
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var dateIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "calendarOrange")
        return image
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
}
