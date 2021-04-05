//
//  TodayCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/5/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class TodayCollectionViewCell: UICollectionViewCell {
//    var menu: Menu? {
//        didSet {
//            configure()
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Funtions
//    func configure() {
//        guard let menu = menu else { return }
//        nameLabel.text = menu.name
//        guard let image = menu.imageUrl else { return }
//        menuImage.loadImage(urlString: image)
//    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(profileImage)
        addSubview(nameLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        shadowView.backgroundColor = .green
        profileImage.anchor(top: shadowView.topAnchor, left: shadowView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        nameLabel.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
    }
    
    var profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "gradientBackground")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Usernamex"
        label.textColor = UIColor.orangeColor()
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 0
        return label
    }()
    
    let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.gray.cgColor
        return view
    }()
}
