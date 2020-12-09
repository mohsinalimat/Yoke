//
//  ScheduleCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class ScheduleCell: UICollectionViewCell {
    
    var dayString = NSMutableAttributedString()
    var user: User?
    
    var schedule: Schedule? {
        didSet {
            guard let schedule = schedule else { return }
            
            eventTitleLabel.text = schedule.title
            notesLabel.text = schedule.note
            dateLabel.text = schedule.scheduleDate
            getBookmarkedUser()
            getTime()
        }
    }
    
    func getTime() {
        if self.schedule?.startTime == "" && self.schedule?.endTime == "" {
            self.startTimeLabel.text = "All Day"
            self.startTimeLabel.textColor = UIColor.mainColor()
            self.startTimeLabel.textAlignment = .center
            self.endTimeLabel.isHidden = true
            self.slashLabel.isHidden = true
        } else {
            self.startTimeLabel.text = schedule?.startTime
            self.endTimeLabel.text = schedule?.endTime
        }
        
    }
    
    func getBookmarkedUser() {
        let uid = schedule?.BookmarkedUser
        if uid == "" {
            self.selectedUser.isHidden = true
        } else {
            Database.fetchUserWithUID(uid: uid!) { (user) in
                self.user = user
                self.selectedUser.text = "With: \(user.username)"
            }
        }
    }
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    var eventTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.black
        return label
    }()
    
    var notesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
//        label.lineBreakMode = .byWordWrapping
//        label.numberOfLines = 2
        return label
    }()
    
    var startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    var slashLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.text = " - "
        return label
    }()
    
    var endTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()
    
    let indicatorButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "indicator"), for: .normal)
        return button
    }()
    
    let selectedUser: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        return label
    }()
    
    let dotView: UIView = {
        let view = UIView()
        view.frame.size.height = 10
        view.frame.size.width = 10
        view.backgroundColor = UIColor.mainColor()
        view.layer.cornerRadius = 5
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(dotView)
        dotView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 10, height: 10)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: dotView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 75, height: 0)
        
        addSubview(eventTitleLabel)
        eventTitleLabel.anchor(top: topAnchor, left: dateLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(indicatorButton)
        indicatorButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [startTimeLabel, slashLabel, endTimeLabel])

        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        addSubview(stackView)
        stackView.anchor(top: dateLabel.topAnchor, left: eventTitleLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(indicatorButton)
        indicatorButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


