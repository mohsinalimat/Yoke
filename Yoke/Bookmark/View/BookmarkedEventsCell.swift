//
//  BookmarkedEventsCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class BookmarkedEventsCell: UICollectionViewCell {
    let ref = Database.database().reference()
    var user: User?
    var event: Event? {
        didSet {
            guard let event = event else { return }
//            profileImageView.loadImage(urlString: event.user.profileImageUrl)
//            usernameLabel.text = event.user.username
//            captionLabel.text = event.caption
//            usernameLabel.text = "Posted by: \(event.user.username)"
            
            
            let dateString = NSMutableAttributedString(string: "")
            let imageDateString = NSTextAttachment()
            imageDateString.image = UIImage(named: "calendar_unselected")
            imageDateString.setImageHeight(height: 15)
            let image2String = NSAttributedString(attachment: imageDateString)
            dateString.append(image2String)
//            dateString.append(NSAttributedString(string: " \(event.eventDate ?? "")"))
            dateLabel.attributedText = dateString
   
            setupBookmarkButton()
        }
    }
    
    var getCurrentUser: Firebase.User? {
        if let currentUser = Auth.auth().currentUser {
            return currentUser
        }

        return nil
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
        ref.removeAllObservers()
        handleBookmarked()
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
        ref.removeAllObservers()
        
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
        let photo = CustomImageView()
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
        return photo
    }()

    let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(updateBookmark), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(captionLabel)
        addSubview(bookmarkButton)
  
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [captionLabel, usernameLabel, dateLabel])
        stackView .axis = .vertical
        stackView .distribution = .equalCentering
        stackView .spacing = 0
        addSubview(stackView)
        stackView.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: bookmarkButton.leftAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        bookmarkButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 30, height: 0)
        bookmarkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


