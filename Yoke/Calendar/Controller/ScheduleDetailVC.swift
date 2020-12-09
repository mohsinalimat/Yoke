//
//  ScheduleDetailVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class ScheduleDetailVC: UIViewController {

    var schedule: Schedule? {
        didSet {
            titleField.text = schedule?.title
            notesField.text = schedule?.note
            
            let dateString = NSMutableAttributedString(string: "")
            let imageDateString = NSTextAttachment()
            imageDateString.image = UIImage(named: "calendarBlack.png")
            imageDateString.setImageHeight(height: 10)
            let image2String = NSAttributedString(attachment: imageDateString)
            dateString.append(image2String)
            dateString.append(NSAttributedString(string: " \(schedule?.scheduleDate ?? "")"))
            dateLabel.attributedText = dateString
            
            let timeString = NSMutableAttributedString(string: "")
            let imageTimeString = NSTextAttachment()
            imageTimeString.image = UIImage(named: "clock.png")
            imageTimeString.setImageHeight(height: 10)
            let image1String = NSAttributedString(attachment: imageTimeString)
            timeString.append(image1String)
            timeString.append(NSAttributedString(string: " \(schedule?.startTime ?? "") - \(schedule?.endTime ?? "")"))
            timeLabel.attributedText = timeString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
    }

    fileprivate func setupViews() {
        view.addSubview(titleField)
        titleField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(notesField)
        notesField.anchor(top: titleField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(dateLabel)
        dateLabel.anchor(top: notesField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(timeLabel)
        timeLabel.anchor(top: dateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    let titleField: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.boldSystemFont(ofSize: 14)
        textView.textColor = UIColor.darkGray
        return textView
    }()
    
    let notesField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.darkGray
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}
