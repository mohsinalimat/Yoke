//
//  BookmarkedUsersTableViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 6/2/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class BookmarkedUsersTableViewCell: UITableViewCell {

    //MARK: - Properties
    var user: User? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Lifecycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Helper Functions
    func configure() {
        guard let user = user else { return }
        nameLabel.text = user.username
        guard let image = user.profileImageUrl,
              let uid = user.uid else { return }
        profileImage.loadImage(urlString: image)
        checkIfBookmarked(bookmarkedUser: uid)
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(cellBackgroundView)
        addSubview(profileImage)
        addSubview(nameLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        cellBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        profileImage.anchor(top: nil, left: cellBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 75, height: 75)
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.anchor(top: profileImage.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: cellBackgroundView.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
    }
    
    func checkIfBookmarked(bookmarkedUser: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        BookmarkController.shared.checkIfBookmarkedUserWith(uid: uid, bookmarkedUid: bookmarkedUser) { result in
            switch result {
            case true:
                let image = UIImage(named: "bookmark_selected")?.withRenderingMode(.alwaysTemplate)
                self.bookmarkButton.setImage(image, for: .normal)
                self.bookmarkButton.setTitle("Bookmarked", for: .normal)
            case false:
                let image = UIImage(named: "bookmark_unselected")?.withRenderingMode(.alwaysTemplate)
                self.bookmarkButton.setImage(image, for: .normal)
                self.bookmarkButton.setTitle("Bookmark", for: .normal)
            }
        }
    }
    
    @objc func handleBookmarked() {
        let userToBookmarkUid = self.userId ?? (Auth.auth().currentUser?.uid ?? "")
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        BookmarkController.shared.bookmarkUserWith(uid: userUid, bookmarkedUid: userToBookmarkUid) { result in
            switch result {
            case true:
                print("true")
            case false:
                print("false")
            }
        }
        BookmarkController.shared.checkIfBookmarkedUserWith(uid: userUid, bookmarkedUid: userToBookmarkUid) { result in
            switch result {
            case true:
                let image = UIImage(named: "bookmark_selected")?.withRenderingMode(.alwaysTemplate)
                self.bookmarkButton.setImage(image, for: .normal)
                self.bookmarkButton.setTitle("Bookmarked", for: .normal)
            case false:
                let image = UIImage(named: "bookmark_unselected")?.withRenderingMode(.alwaysTemplate)
                self.bookmarkButton.setImage(image, for: .normal)
                self.bookmarkButton.setTitle("Bookmark", for: .normal)
            }
        }
    }
    
    //MARK: - Views
    var cellBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 75 / 2
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
}
