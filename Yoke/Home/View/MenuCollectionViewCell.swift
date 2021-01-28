//
//  MenuCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/28/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseStorage

class MenuCollectionViewCell: UICollectionViewCell {
    
    let imageStorageRef = Storage.storage().reference()
    
    var menu: Menu? {
        didSet {
            guard let menu = menu else { return }
            nameLabel.text = menu.name
            guard let course = menu.courseType else { return }
            courseTypeLabel.text = "Course: \(course)"
            detailLabel.text = menu.detail
            guard let image = menu.imageUrl else { return }
            menuImage.loadImage(urlString: image)
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
        addSubview(menuImage)
        addSubview(nameLabel)
        addSubview(courseTypeLabel)
//        addSubview(detailLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        menuImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: frame.width, height: frame.width - 20)
//        menuImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.anchor(top: menuImage.bottomAnchor, left: menuImage.leftAnchor, bottom: nil, right: menuImage.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        courseTypeLabel.anchor(top: nameLabel.bottomAnchor, left: menuImage.leftAnchor, bottom: nil, right: menuImage.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
//        detailLabel.anchor(top: courseTypeLabel.bottomAnchor, left: menuImage.leftAnchor, bottom: nil, right: menuImage.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    var menuImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.backgroundColor = .yellow
        image.layer.cornerRadius = 5
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
    
    var courseTypeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
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
