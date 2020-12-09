//
//  ChatHeaderCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 6/3/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol chatHeaderDelegate {
    func viewDetails(user: User)
}

class ChatHeaderCell: UICollectionViewCell {
    
    var delegate: chatHeaderDelegate?
    
    var user: User? {
        didSet {
            guard let user = user else {return}
            let profileImageUrl = user.profileImageUrl
            if let url = URL(string: profileImageUrl) {
                let placeholder = UIImage(named: "image_background")
                profileImageView.kf.indicatorType = .activity
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                profileImageView.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
            usernameLabel.text = user.username
            
        }
    }

    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
//        imageView.image = UIImage(named: "chef-in-uniform")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    lazy var detailsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Details", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleDetails), for: .touchUpInside)
        return button
    }()
    
    @objc func handleDetails() {
        guard let user = user else {return}
        delegate?.viewDetails(user: user)
    }

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "Jenna Yang"
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "July 12th"
        return label
    }()
    
    let slashLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "|"
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "10:30 am - 11:30 am"
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = "$115 total, including service fee"
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(totalLabel)
        addSubview(detailsButton)
        
        profileImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        profileImageView.layer.cornerRadius = 30
        profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, slashLabel, timeLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        addSubview(stackView)
        stackView.anchor(top: usernameLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        totalLabel.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        detailsButton.anchor(top: totalLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
