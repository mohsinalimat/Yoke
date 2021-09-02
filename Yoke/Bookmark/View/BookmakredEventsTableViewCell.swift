//
//  BookmakredEventsTableViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 6/2/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class BookmakredEventsTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var event: Event? {
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
        guard let event = event,
              let start = event.startTime,
              let end = event.endTime else { return }
        nameLabel.text = event.caption
        locationLabel.text = event.shortLocation
        dateLabel.text = event.date
        timeLabel.text = "\(start) - \(end)"
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(nameLabel)
        addSubview(locationIcon)
        addSubview(locationLabel)
        addSubview(dateIcon)
        addSubview(dateLabel)
        addSubview(timeIcon)
        addSubview(timeLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        //        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.anchor(top: cellBackgroundView.topAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        locationIcon.anchor(top: nameLabel.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 18)
        locationLabel.anchor(top: nil, left: locationIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        dateIcon.anchor(top: locationIcon.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
        timeIcon.anchor(top: dateIcon.bottomAnchor, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        timeLabel.anchor(top: timeIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
    }
    
    //MARK: - Views
    var cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
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
        label.font = UIFont.boldSystemFont(ofSize: 17)
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
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    var timeIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeOrange")
        return image
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
}
