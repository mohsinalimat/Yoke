//
//  UserEventCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

protocol userEventCellDelegate {
    func deleteEvent(at index: IndexPath)
}

class UserEventCell: UICollectionViewCell {
    
    var user: User?
    var event: Event? {
        didSet {
            guard let event = event else {return}
            captionLabel.text = event.caption
            postTextView.text = event.postText
            creationTimeLabel.text = event.creationDate?.timeAgoDisplay()
            
            guard let count = event.bookmarkCount else {return}
            self.bookmarkedCountLabel.text = "\(Int(count))"
            photoImageView.loadImage(urlString: event.eventImageUrl!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            creationTimeLabel.text = "Created on: " + dateFormatter.string(from: (event.creationDate)!)
            
            setupBookmarkButton()
            setupDateTimeView()
            setupCreationDateView()
            updateCount()
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
    }
    
    func setupDateTimeView() {
        if event?.eventDate != "" {
            let dateString = NSMutableAttributedString(string: "")
            let imageDateString = NSTextAttachment()
            imageDateString.image = UIImage(named: "calendar_unselected")
            imageDateString.setImageHeight(height: 12)
            let image2String = NSAttributedString(attachment: imageDateString)
            dateString.append(image2String)
            dateString.append(NSAttributedString(string: " \(event?.eventDate ?? "")"))
            dateLabel.attributedText = dateString
        }
        
        if event?.startTime != "" || event?.endTime != "" {
            let timeString = NSMutableAttributedString(string: "")
            let imageTimeString = NSTextAttachment()
            imageTimeString.image = UIImage(named: "clock")
            imageTimeString.setImageHeight(height: 12)
            let image1String = NSAttributedString(attachment: imageTimeString)
            timeString.append(image1String)
            timeString.append(NSAttributedString(string: " \(event?.startTime ?? "") - \(event?.endTime ?? "")"))
            timeLabel.attributedText = timeString
        }
        
        if event?.address != "" {
            let addressString = NSMutableAttributedString(string: "")
            let imageAddressString = NSTextAttachment()
            imageAddressString.image = UIImage(named: "location")
            imageAddressString.setImageHeight(height: 12)
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
        updateCount()
        handleBookmarked()
    }
    
    func handleBookmarked() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let eventId = event?.id else {return}
        let ref = Database.database().reference().child(Constants.BookmarkedEvents).child(currentUserId)
        //        let values = [userId: 1, Constants.Id: eventId] as [String : Any]
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
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
//        image.layer.cornerRadius = 10
//        image.layer.borderColor = UIColor.white.cgColor
//        image.layer.borderWidth = 1
        return image
    }()

    let userLocation: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let creationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let postTextView: UITextView = {
        let text = UITextView()
        text.textColor = UIColor.darkGray
        text.font = UIFont.systemFont(ofSize: 14)
        text.isEditable = false
        text.isScrollEnabled = false
        text.backgroundColor = .clear
        return text
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bookmarkedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0"
        label.textAlignment = .center
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 2
        let image = UIImage(named: "bookmark_unselected")
        button.setImage(image, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(updateBookmark), for: .touchUpInside)
        return button
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 2
        button.setImage(UIImage(named: "messageWhite"), for: .normal)
        button.setTitle(" Message", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
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
        addSubview(photoImageView)
        addSubview(captionLabel)
        addSubview(creationTimeLabel)
        addSubview(postTextView)
        addSubview(bookmarkButton)
        addSubview(bookmarkedCountLabel)
        addSubview(messageButton)
        addSubview(addressLabel)
        
//        sepView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0.5)
        
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

        
        let bookmarkView = UIStackView(arrangedSubviews: [bookmarkButton, bookmarkedCountLabel])
        bookmarkView.axis = .vertical
        bookmarkView.distribution = .equalCentering
        bookmarkView.spacing = 0
        addSubview(bookmarkView)
        bookmarkView.anchor(top: postTextView.bottomAnchor, left: nil, bottom: nil, right: photoImageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
