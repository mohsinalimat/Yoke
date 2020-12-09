//
//  DateCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateCell: JTAppleCell {
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.layer.cornerRadius = 5
        return label
    }()
    
    let selectedView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = UIColor.orangeColor()
        view.layer.borderColor = UIColor.orangeColor()?.cgColor
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 5
        return view
    }()
    
    let blackoutView: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = UIColor(patternImage: UIImage(named: "blackoutDate.png")!)
        view.backgroundColor = UIColor.lightGray
        view.contentMode = UIView.ContentMode.scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    let eventView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
    let todayView: UIImageView = {
        let view = UIImageView()
        view.layer.borderColor = UIColor.yellowColor()?.cgColor
        view.backgroundColor = UIColor.yellowColor()
        view.layer.borderWidth = 3
        view.layer.cornerRadius = 2
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(blackoutView)
        blackoutView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        blackoutView.isHidden = true
        
        addSubview(selectedView)
        selectedView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 2, paddingBottom: 2, paddingRight: 2, width: 0, height: 0)
        selectedView.isHidden = true
        
        addSubview(todayView)
        todayView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 3, paddingBottom: 2, paddingRight: 3, width: 0, height: 0)
        todayView.isHidden = true
        
        addSubview(dayLabel)
        dayLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: -3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(eventView)
        eventView.anchor(top: dayLabel.bottomAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 3, paddingRight: 0, width: 8, height: 8)
        eventView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        eventView.isHidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("DayCell init with coder is not implemented.")
    }
}
