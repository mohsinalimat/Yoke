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
        guard let event = event,
              let eventImg = event.eventImageUrl else { return }
        let timestamp = event.timestamp.timeAgoDisplay()
        eventImage.loadImage(urlString: eventImg)
        timestampLabel.text = "Posted \(timestamp) ago"
        captionLabel.text = event.caption
        dateLabel.text = event.date
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(eventImage)
        addSubview(timestampLabel)
        addSubview(captionLabel)
        addSubview(dateIcon)
        addSubview(dateLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        eventImage.anchor(top: shadowView.topAnchor, left: shadowView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 120, height: 120)
        timestampLabel.anchor(top: shadowView.topAnchor, left: nil, bottom: nil, right: shadowView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5)
        captionLabel.anchor(top: eventImage.topAnchor, left: eventImage.rightAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 35, paddingLeft: 5, paddingBottom: 0, paddingRight: 10)
//        captionLabel.centerYAnchor.constraint(equalTo: eventImage.centerYAnchor).isActive = true
        dateIcon.anchor(top: captionLabel.bottomAnchor, left: eventImage.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
    }
    
    //MARK: Views
    var eventImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "gradientBackgroundHalf")
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
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
        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 2
        label.textAlignment = .left
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
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
}
