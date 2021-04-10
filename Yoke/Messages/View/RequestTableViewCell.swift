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
            UserController.shared.fetchUsers(uid: booking.userUid) { (user) in
                print("username \(user.username)")
                self.nameLabel.text = user.username
                guard let image = user.profileImageUrl else { return }
                self.profileImage.loadImage(urlString: image)
            }
        } else if booking.userUid == Auth.auth().currentUser?.uid ?? "" {
            UserController.shared.fetchUsers(uid: booking.chefUid ?? "") { (user) in
                print("username \(user.username)")
                self.nameLabel.text = user.username
                guard let image = user.profileImageUrl else { return }
                self.profileImage.loadImage(urlString: image)
            }
        }
        
        timestampLabel.text = booking.timestamp.timeAgoDisplay()
    }

    func setupViews() {
        addSubview(shadowView)
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(textView)
        addSubview(timestampLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        profileImage.anchor(top: nil, left: shadowView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 75, height: 75)
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.anchor(top: profileImage.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        textView.anchor(top: nameLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: shadowView.bottomAnchor, right: shadowView.rightAnchor, paddingTop: -6, paddingLeft: 2, paddingBottom: 0, paddingRight: 5)
        timestampLabel.anchor(top: shadowView.topAnchor, left: nil, bottom: nil, right: shadowView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5)
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
    
    private let textView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.font = UIFont.systemFont(ofSize: 15)
        text.isScrollEnabled = false
        text.isEditable = false
        text.textColor = .gray
        return text
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
}
