//
//  EventCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

protocol EventDelegate {
    func bookmarkPost(user: User)
}

class EventCell: UICollectionViewCell {
    let ref = Database.database().reference()
    var delegate: EventDelegate?
    var user: User?
    var event: Event? {
        didSet {
            guard let event = event else { return }
            captionLabel.text = event.caption
            usernameLabel.text = event.user.username
            let profileImageUrl = event.user.profileImageUrl
            if let url = URL(string: profileImageUrl) {
                let placeholder = UIImage(named: "placeholder")
                profileImageView.kf.indicatorType = .activity
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                profileImageView.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
            
            let attributedText = NSMutableAttributedString(string: event.postText ?? "", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            attributedText.append(NSAttributedString(string: " ", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-BlackOblique", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
            postTextView.attributedText = attributedText
            
            guard let eventImageUrl = event.eventImageUrl else {return}
            if let url = URL(string: eventImageUrl) {
                let placeholder = UIImage(named: "image_background")
                photoImageView.kf.indicatorType = .activity
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                photoImageView.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
//            photoImageView.loadImage(urlString: eventImageUrl)
            
            guard let count = event.bookmarkCount else {return}
            self.bookmarkedCountLabel.text = "\(Int(count))"
            
            setupDateTimeAddressView()
            
            setupBookmarkButton()
            updateCount()
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            creationTimeLabel.text = "Created on: " + dateFormatter.string(from: (event.creationDate)!)
        }
    }
    
    func setupCreationDateView() {
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        dateFormatter.doesRelativeDateFormatting = true
        
        if calendar.isDateInToday((event?.creationDate)!) {
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .none
        } else if calendar.isDateInYesterday((event?.creationDate)!){
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
            
        } else if calendar.compare(Date(), to: (event?.creationDate)!, toGranularity: .weekOfYear) == .orderedSame {
            let weekday = calendar.dateComponents([.weekday], from: (event?.creationDate)!).weekday ?? 0
            return print("this is the weekday \(weekday)")
            
            //                return dateFormatter.weekdaySymbols[weekday-1]
        } else {
            dateFormatter.timeStyle = .none
            dateFormatter.dateStyle = .medium
        }
        
        creationTimeLabel.text = dateFormatter.string(from: (event?.creationDate)!)
    }
    
    func setupDateTimeAddressView() {
        
        if event?.eventDate != "" {
            let dateString = NSMutableAttributedString(string: "")
            let imageDateString = NSTextAttachment()
            imageDateString.image = UIImage(named: "calendar_unselected")
            imageDateString.setImageHeight(height: 15)
            let image2String = NSAttributedString(attachment: imageDateString)
            dateString.append(image2String)
            dateString.append(NSAttributedString(string: " \(event?.eventDate ?? "")"))
            dateLabel.attributedText = dateString
        }
        
        if event?.startTime != "" || event?.endTime != "" {
            let timeString = NSMutableAttributedString(string: "")
            let imageTimeString = NSTextAttachment()
            imageTimeString.image = UIImage(named: "clock.png")
            imageTimeString.setImageHeight(height: 15)
            let image1String = NSAttributedString(attachment: imageTimeString)
            timeString.append(image1String)
            timeString.append(NSAttributedString(string: " \(event?.startTime ?? "") - \(event?.endTime ?? "")"))
            timeLabel.attributedText = timeString
        }
    
        if event?.address != "" {
            let addressString = NSMutableAttributedString(string: "")
            let imageAddressString = NSTextAttachment()
            imageAddressString.image = UIImage(named: "location")
            imageAddressString.setImageHeight(height: 15)
            let image1String = NSAttributedString(attachment: imageAddressString)
            addressString.append(image1String)
            addressString.append(NSAttributedString(string: " \(event?.address ?? "")"))
            addressLabel.attributedText = addressString
        }
        
    }
    
    var getCurrentUser: Firebase.User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }

        return nil
    }
    
    func updateCount() {
        let getId = self.event?.id
        Database.database().reference().child(Constants.Event).child(getId!).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int {
                self.bookmarkedCountLabel.text = "\(value)"
            }
        })
    }
    
    @objc func updateBookmark() {
        print("updatebookmark")
        let getId = self.event?.id
        let postRef = Database.database().reference().child(Constants.Event).child(getId!)
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var user = currentData.value as? [String : AnyObject], let uid = self.getCurrentUser?.uid {
                var bookmarks: Dictionary<String, Bool>
                bookmarks = user[Constants.Bookmarks] as? [String : Bool] ?? [:]
                var bookmarkCount = user[Constants.BookmarkCount] as? Int ?? 0
                if let _ = bookmarks[uid] {
                    bookmarkCount -= 1
                    bookmarks.removeValue(forKey: uid)
                } else {
                    bookmarkCount += 1
                    bookmarks[uid] = true
                }
                user[Constants.BookmarkCount] = bookmarkCount as AnyObject?
                user[Constants.Bookmarks] = bookmarks as AnyObject?
                currentData.value = user
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error)
            }
        }
        ref.removeAllObservers()
        handleBookmarked()
        updateCount()
    }
    
    func handleBookmarked() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let eventId = event?.id else {return}
        let ref = Database.database().reference().child(Constants.BookmarkedEvents).child(currentUserId)
        let values = [eventId: 1] as [String : Any]
        if bookmarkButton.isSelected {
            ref.child(eventId).removeValue(completionBlock: { (err, ref) in
                if let err = err {
                    print("failed to un-save", err)
                    return
                }
            })
        } else {
            ref.updateChildValues((values)) { (err, ref) in
                if let err = err {
                    print("failed to save user", err)
                    return
                }
            }
        }
    }

    func setupBookmarkButton() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let eventId = event?.id else {return}
        Database.database().reference().child(Constants.BookmarkedEvents).child(currentUserId).child(eventId).observe(.value, with: { (snapshot) in
            if let isSaved = snapshot.value as? Int, isSaved == 1 {
                self.bookmarkButton.isSelected = true
                self.bookmarkButton.setImage(UIImage(named: "bookmark_selected"), for: .normal)
            } else {
                self.bookmarkButton.isSelected = false
                self.bookmarkButton.setImage(UIImage(named: "bookmark_unselected"), for: .normal)
            }
        }) { (err) in
            print("failed to check saved", err)
        }
    }
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
//        image.image = 
        return image
    }()
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
//        image.layer.cornerRadius = 10
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 1
        return image
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let creationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.textAlignment = .justified
        text.textColor = UIColor.darkGray
        text.font = UIFont.systemFont(ofSize: 15)
        text.isEditable = false
        text.isScrollEnabled = false
        return text
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bookmarkedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bookmark_unselected"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(updateBookmark), for: .touchUpInside)
        return button
    }()
    
    let sepView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sepView)
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(captionLabel)
        addSubview(creationTimeLabel)
        addSubview(postTextView)
        addSubview(addressLabel)
        
        
//        sepView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0.5)

        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        
        usernameLabel.anchor(top: profileImageView.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        creationTimeLabel.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        photoImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width, height: frame.width / 2)

        captionLabel.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, timeLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.spacing = 5
        addSubview(stackView)
        stackView.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        addressLabel.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 20, width: 0, height: 20)

        postTextView.anchor(top: addressLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 7, paddingBottom: 10, paddingRight: 5, width: 0, height: 0)

//        let bookmarkView = UIStackView(arrangedSubviews: [bookmarkButton, bookmarkedCountLabel])
//        bookmarkView.axis = .vertical
//        bookmarkView.distribution = .equalCentering
//        bookmarkView.spacing = 0
//        addSubview(bookmarkView)
//        bookmarkView.anchor(top: stackView.topAnchor, left: nil, bottom: stackView.bottomAnchor, right: photoImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


