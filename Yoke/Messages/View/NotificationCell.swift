//
//  NotificationCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 4/8/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class NotificationCell: UITableViewCell {
    
    var user: User?
    var notification: Notifications? {
        didSet {
            guard let notification = notification else {return}
            if notification.notificationType == "payment" {
                titleMessageLabel.text = "Please complete payment to book"
            }
            fromLabel.text = "From: Jonny Goodpants"
            messageLabel.text = "Reference: \(String(describing: notification.reference ?? "" ))"


            let dateFormatter = DateFormatter()
            let calendar = Calendar(identifier: .gregorian)
            dateFormatter.doesRelativeDateFormatting = true
            
            if calendar.isDateInToday((notification.creationDate)!) {
                dateFormatter.timeStyle = .short
                dateFormatter.dateStyle = .none
            } else if calendar.isDateInYesterday((notification.creationDate)!){
                dateFormatter.timeStyle = .none
                dateFormatter.dateStyle = .medium
                
            } else if calendar.compare(Date(), to: (notification.creationDate)!, toGranularity: .weekOfYear) == .orderedSame {
                let weekday = calendar.dateComponents([.weekday], from: (notification.creationDate)!).weekday ?? 0
                return print("this is the weekday \(weekday)")
            } else {
                dateFormatter.timeStyle = .none
                dateFormatter.dateStyle = .medium
            }
            
            timeLabel.text = dateFormatter.string(from: (notification.creationDate)!)
            
        }
    }
    
    let notificationCircle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    let titleMessageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fromLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(notificationCircle)
        addSubview(timeLabel)
        addSubview(titleMessageLabel)
        addSubview(fromLabel)
        addSubview(messageLabel)
        
        titleMessageLabel.anchor(top: topAnchor, left: notificationCircle.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
        fromLabel.anchor(top: titleMessageLabel.bottomAnchor, left: titleMessageLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        messageLabel.anchor(top: fromLabel.bottomAnchor, left: titleMessageLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        notificationCircle.anchor(top: titleMessageLabel.topAnchor, left: leftAnchor, bottom: titleMessageLabel.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 10, height: 10)
        notificationCircle.layer.cornerRadius = 10 / 2

        timeLabel.anchor(top: titleMessageLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: -3, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }
    
}

