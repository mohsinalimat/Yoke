//
//  EditEventCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class EditEventCell: UICollectionViewCell {
    
    var user: User?
    var event: Event? {
        didSet {
            guard let event = event else { return }
            captionLabel.text = event.caption
            postTextView.text = event.postText
            creationTimeLabel.text = event.creationDate?.timeAgoDisplay()
            photoImageView.loadImage(urlString: event.eventImageUrl!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            creationTimeLabel.text = "Created on: " + dateFormatter.string(from: (event.creationDate)!)
            
            let style = NSMutableParagraphStyle()
            style.alignment = NSTextAlignment.center
            
            let attributedText = NSMutableAttributedString(string: "There are no photos to accompany this event.", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.paragraphStyle: style])
            attributedText.append(NSAttributedString(string: "\n" + "Adding photos to your event will draw more attention!", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-BookOblique", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.paragraphStyle: style]))
            noImageTextView.attributedText = attributedText

            if event.eventDate != "" {
                let dateString = NSMutableAttributedString(string: "")
                let imageDateString = NSTextAttachment()
                imageDateString.image = UIImage(named: "calendar_unselected.png")
                imageDateString.setImageHeight(height: 12)
                let image2String = NSAttributedString(attachment: imageDateString)
                dateString.append(image2String)
                dateString.append(NSAttributedString(string: " \(event.eventDate ?? "")"))
                dateLabel.attributedText = dateString
            }
            
            if event.startTime != "" || event.endTime != "" {
                let timeString = NSMutableAttributedString(string: "")
                let imageTimeString = NSTextAttachment()
                imageTimeString.image = UIImage(named: "clock.png")
                imageTimeString.setImageHeight(height: 12)
                let image1String = NSAttributedString(attachment: imageTimeString)
                timeString.append(image1String)
                timeString.append(NSAttributedString(string: " \(event.startTime ?? "") - \(event.endTime ?? "")"))
                timeLabel.attributedText = timeString
            }
            
            if event.address != "" {
                let addressString = NSMutableAttributedString(string: "")
                let imageAddressString = NSTextAttachment()
                imageAddressString.image = UIImage(named: "location")
                imageAddressString.setImageHeight(height: 12)
                let image1String = NSAttributedString(attachment: imageAddressString)
                addressString.append(image1String)
                addressString.append(NSAttributedString(string: " \(event.address ?? "")"))
                addressLabel.attributedText = addressString
            }
        }
    }
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postTextView: UITextView = {
        let text = UITextView()
        text.textColor = UIColor.darkGray
        text.font = UIFont.systemFont(ofSize: 14)
        text.isEditable = false
        text.isScrollEnabled = false
        text.textAlignment = .left
        return text
    }()
    
    let noImageTextView: UITextView = {
        let text = UITextView()
        text.isEditable = false
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return text
    }()
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let creationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.mainColor()
        button.layer.cornerRadius = 2
        return button
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        addSubview(noImageTextView)
        addSubview(photoImageView)
        addSubview(captionLabel)
        addSubview(creationTimeLabel)
        addSubview(editButton)
        addSubview(postTextView)
        addSubview(addressLabel)
        
        creationTimeLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        photoImageView.anchor(top: creationTimeLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: frame.width / 2)
        
        captionLabel.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 6, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        let dateTimeView = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
        dateTimeView .axis = .vertical
        dateTimeView .distribution = .equalCentering
        dateTimeView .spacing = 5
        addSubview(dateTimeView)
        dateTimeView.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        addressLabel.anchor(top: dateTimeView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 20)
        
        postTextView.anchor(top: addressLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 7, paddingBottom: 10, paddingRight: 5, width: 0, height: 0)
        
        editButton.anchor(top: postTextView.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 15, paddingRight: 10, width: 50, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
