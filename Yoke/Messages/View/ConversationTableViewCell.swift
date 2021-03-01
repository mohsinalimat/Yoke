//
//  ConversationTableViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    //MARK: - Properties
    var conversation: Conversation? {
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
        guard let conversation = conversation else { return }
        nameLabel.text = conversation.user.username
        textView.text = conversation.message.text
        guard let image = conversation.user.profileImageUrl else { return }
        profileImage.loadImage(urlString: image)
        timestampLabel.text = conversation.message.timestamp.timeAgoDisplay()
    }

    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(textView)
        addSubview(timestampLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        profileImage.anchor(top: nil, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 50, height: 50)
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.anchor(top: profileImage.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        textView.anchor(top: nameLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: -6, paddingLeft: 2, paddingBottom: 0, paddingRight: 5)
        timestampLabel.anchor(top: cellBackgroundView.topAnchor, left: nil, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5)
    }
    
    //MARK: - Views
    let cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
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
        image.layer.cornerRadius = 50 / 2
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .white
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
        text.textColor = .white
        return text
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()

}
