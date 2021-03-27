//
//  ChefsEventsCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class ChefsEventsCollectionViewCell: UICollectionViewCell {
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
        guard let event = event else { return }
        let timestamp = event.timestamp.timeAgoDisplay()
        timestampLabel.text = "Posted \(timestamp) ago"
        captionLabel.text = event.caption
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(timestampLabel)
        addSubview(captionLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        timestampLabel.anchor(top: cellBackgroundView.topAnchor, left: nil, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5)
        captionLabel.anchor(top: timestampLabel.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
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
    
    var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    let cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
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
