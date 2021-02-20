//
//  MessageCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class MessageCell: UITableViewCell {
    var user: User?
    var message: Message? {
        didSet {
            guard let message = message else {return}
            messageView.text = message.content
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.dateStyle = DateFormatter.Style.short
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: message.sentDate)
            timestampLabel.text = localDate
            fetchUser()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemeted")
    }

    func setupViews() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(messageView)
        addSubview(timestampLabel)
    }

    func setupConstraints() {
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
//        usernameLabel.anchor(top: profileImageView.topAnchor, bottom: nil, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 10, trailingPadding: 40)
//        messageView.anchor(top: usernameLabel.bottomAnchor, bottom: nil, leading: profileImageView.trailingAnchor, trailing: trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 5, trailingPadding: 0)
//        timestampLabel.anchor(top: usernameLabel.topAnchor, bottom: nil, leading: nil, trailing: trailingAnchor, topPadding: 0, bottomPadding: 0, leadingPadding: 10, trailingPadding: -10)
    }

    fileprivate func fetchUser() {
        guard let senderUid = message?.toId, let currentUid = message?.senderID else { return }
        if senderUid == Auth.auth().currentUser?.uid {
            UserController.shared.fetchUserWithUID(uid: currentUid) { (user) in
                self.usernameLabel.text = user.username
                Storage.storage().reference().child("profileImage/\(currentUid)").getData(maxSize: 2 * 1024 * 1024) { data, error in
                    if error == nil, let data = data {
                        self.profileImageView.image = UIImage(data: data)
                    }
                }
            }
        } else {
            UserController.shared.fetchUserWithUID(uid: senderUid) { (user) in
                self.usernameLabel.text = user.username
                Storage.storage().reference().child("profileImage/\(senderUid)").getData(maxSize: 2 * 1024 * 1024) { data, error in
                    if error == nil, let data = data {
                        self.profileImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }

    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 30
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .lightGray
        image.layer.cornerRadius = 40/2
        return image
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    let messageView: UITextView = {
        let text = UITextView()
        text.textAlignment = .justified
        text.textColor = .darkGray
        text.isEditable = false
        text.isScrollEnabled = false
        text.textContainer.maximumNumberOfLines = 1
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 14)
        text.backgroundColor = .clear
        return text
    }()

    let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

    
//    var user: User?
//    var message: Message? {
//        didSet {
//            guard let message = message else {return}
//            setupNameAndProfileImage()
//            
//            if message.imageUrl == nil {
//                textView.text = message.text
//                
//            } else {
//                textView.font = UIFont.italicSystemFont(ofSize: 14)
//                textView.textColor = UIColor.lightGray
//                textView.text = "Media Attached"
//            }
//            
////            textView.text = message.text
//            
//            let dateFormatter = DateFormatter()
//            let calendar = Calendar(identifier: .gregorian)
//            dateFormatter.doesRelativeDateFormatting = true
//            
//            if calendar.isDateInToday((message.creationDate)!) {
//                dateFormatter.timeStyle = .short
//                dateFormatter.dateStyle = .none
//            } else if calendar.isDateInYesterday((message.creationDate)!){
//                dateFormatter.timeStyle = .none
//                dateFormatter.dateStyle = .medium
//                
//            } else if calendar.compare(Date(), to: (message.creationDate)!, toGranularity: .weekOfYear) == .orderedSame {
//                let weekday = calendar.dateComponents([.weekday], from: (message.creationDate)!).weekday ?? 0
//                return print("this is the weekday \(weekday)")
//                
//                //                return dateFormatter.weekdaySymbols[weekday-1]
//            } else {
//                dateFormatter.timeStyle = .none
//                dateFormatter.dateStyle = .medium
//            }
//            
//            timeLabel.text = dateFormatter.string(from: (message.creationDate)!)
//            
//        }
//    }
//    
//    fileprivate func setupNameAndProfileImage() {
//        if let id = message?.chatPartnerId() {
//            let ref = Database.database().reference().child(Constants.Users).child(id)
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    self.usernameLabel.text = dictionary[Constants.Username] as? String
//                    if let profileImageUrl = dictionary[Constants.ProfileImageUrl] as? String {
//                        self.profileImageView.loadImage(urlString: profileImageUrl)
//                    }
//                }
//            }, withCancel: nil)
//        }
//        
//        if let id = message?.chatPartnerId() {
//            let ref = Database.database().reference().child(Constants.Chefs).child(id)
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//                
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    self.usernameLabel.text = dictionary[Constants.Username] as? String
//                    if let profileImageUrl = dictionary[Constants.ProfileImageUrl] as? String {
//                        self.profileImageView.loadImage(urlString: profileImageUrl)
//                        
//                    }
//                }
//            }, withCancel: nil)
//        }
//    }
//    
//    let profileImageView: CustomImageView = {
//        let image = CustomImageView()
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.layer.cornerRadius = 30
//        image.layer.masksToBounds = true
//        image.contentMode = .scaleAspectFill
//        return image
//    }()
//    
//    let usernameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.black
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        return label
//    }()
//    
//    let timeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.textColor = UIColor.lightGray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let textView: UITextView = {
//        let text = UITextView()
//        text.backgroundColor = .clear
//        text.textAlignment = .justified
//        text.textColor = UIColor.black
//        text.isEditable = false
//        text.isScrollEnabled = false
//        text.textContainer.maximumNumberOfLines = 2
//        text.textContainer.lineBreakMode = .byWordWrapping
//        text.font = UIFont.systemFont(ofSize: 14)
//        return text
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        
//        addSubview(profileImageView)
//        addSubview(usernameLabel)
//        addSubview(timeLabel)
//        addSubview(textView)
//        
//        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
//        
//        usernameLabel.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//        timeLabel.anchor(top: usernameLabel.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
//        
//        textView.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: -5, paddingLeft: 3, paddingBottom: 0, paddingRight: 30, width: 250, height: 0)
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemeted")
//    }
    
//}
