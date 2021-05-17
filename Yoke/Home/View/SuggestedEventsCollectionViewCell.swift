//
//  SuggestedEventsCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 5/14/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class SuggestedEventsCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    let firestoreDB = Firestore.firestore()
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
    
    //MARK: - Helper Functions
    func configure() {
        guard let event = event else { return }
        guard let image = event.eventImageUrl else { return }
        eventImage.loadImage(urlString: image)
        captionLabel.text = event.caption
        locationLabel.text = event.shortLocation
        dateLabel.text = event.date
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(eventImage)
        addSubview(cellBackgroundImage)
        addSubview(captionLabel)
        addSubview(locationLabel)
        addSubview(locationIcon)
        addSubview(dateLabel)
        addSubview(dateIcon)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        eventImage.anchor(top: shadowView.topAnchor, left: shadowView.leftAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: frame.height / 2)
        cellBackgroundImage.anchor(top: eventImage.topAnchor, left: eventImage.leftAnchor, bottom: eventImage.bottomAnchor, right: eventImage.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        captionLabel.anchor(top: eventImage.topAnchor, left: eventImage.leftAnchor, bottom: eventImage.bottomAnchor, right: eventImage.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8)

        locationIcon.anchor(top: eventImage.bottomAnchor, left: eventImage.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 18)
        locationLabel.anchor(top: nil, left: locationIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        
        dateIcon.anchor(top: locationIcon.bottomAnchor, left: eventImage.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
    }
    
    //MARK: Views
    var eventImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "gradientBackgroundHalf")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        return image
    }()
    
    var captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    var locationIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "location-pin-orange")
        return image
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
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
    
    let cellBackgroundImage: UIImageView = {
        let view = UIImageView()
//        view.image = UIImage(named: "menuCover")
//        view.contentMode = .scaleAspectFill
        view.backgroundColor = .black.withAlphaComponent(0.4)
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        return view
    }()
}
