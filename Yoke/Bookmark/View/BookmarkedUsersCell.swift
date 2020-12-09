//
//  BookmarkedUsersCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class BookmarkedUsersCell: UICollectionViewCell {
    let ref = Database.database().reference()
    var user: User? {
        didSet {
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            usernameLabel.text = user?.username

            setupBookmarkButton()
        }
    }


    
    @objc func handleBookmark() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        guard let userId = user?.uid else {return}
        let ref = Database.database().reference().child(Constants.BookmarkedUsers).child(currentUserId)
        let values = [userId: 1]
        
        if bookmarkButton.isSelected {
            ref.child(userId).removeValue(completionBlock: { (err, ref) in
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
        guard let userId = user?.uid else {return}
        Database.database().reference().child(Constants.BookmarkedUsers).child(currentUserId).child(userId).observe(.value, with: { (snapshot) in
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
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(handleBookmark), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(bookmarkButton)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        bookmarkButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 25, width: 30, height: 0)
        bookmarkButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
