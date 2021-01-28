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
        addSubview(menuImage)
        addSubview(nameLabel)
        addSubview(courseTypeLabel)
        addSubview(detailLabel)
    }
    
    func setupConstraints() {
        menuImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: frame.width, height: 150)
        nameLabel.anchor(top: menuImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        courseTypeLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        detailLabel.anchor(top: courseTypeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
    }
    
    var menuImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.backgroundColor = .yellow
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .gray
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
}
