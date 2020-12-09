//
//  GalleryDetailVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class GalleryDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccessoryViewDelegate {

    let currentUser = Auth.auth().currentUser
    let cellId = "cellId"
    
    var userId: String?
    var user: User?
    var gallery: Gallery? {
        didSet {
            
            userId = gallery?.user.uid
            likeButton.setImage(gallery?.hasLiked == true ? UIImage(named: "like_selected") : UIImage(named: "like_unselected"), for: .normal)
            getBookmarkedUser()

            guard let count = gallery?.likeCount else {return}
            self.likeLabel.text = "\(Int(count))"
//            self.captionLabel.text = gallery?.caption

            if gallery?.caption != "" {
                getGalleryCaption()
            }
            
            if gallery?.location != "" {
                getGalleryLocation()
            }

            guard let imageUrl = gallery?.imageUrl else { return }
            if let url = URL(string: imageUrl) {
                let placeholder = UIImage(named: "image_background")
                photoImageView.kf.indicatorType = .activity
                let options : KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.2))]
                photoImageView.kf.setImage(with: url, placeholder: placeholder, options: options)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets.init(top: 15, left: 0, bottom: 25, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        scrollView.keyboardDismissMode = .onDrag
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellId)
        
        if gallery?.user.uid == currentUser?.uid {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
        
        setupLikeButton()
        setupViews()
        updateLikeCount()
        containerView.isHidden = true
        fetchComments()
    }
    
    func getGalleryCaption() {
    Database.database().reference().child(Constants.Gallery).child((gallery?.user.uid)!).child(gallery!.id!).observe(.value) { (snapshot) in
        
        if let dict = snapshot.value as? [String: Any] {
            let caption = dict[Constants.Caption] as! String
            self.captionLabel.text = caption
        }
            
        }
    }
    
    func getGalleryLocation() {
        Database.database().reference().child(Constants.Gallery).child((gallery?.user.uid)!).child(gallery!.id!).observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let location = dict[Constants.Location] as! String
                print("location \(location)")
                let locationString = NSMutableAttributedString(string: "")
                let imageString = NSTextAttachment()
                imageString.image = UIImage(named: "location")
                imageString.setImageHeight(height: 15)
                let image2String = NSAttributedString(attachment: imageString)
                locationString.append(image2String)
                locationString.append(NSAttributedString(string: " \(location)"))
                self.locationLabel.attributedText = locationString
            }
            

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func handleRefresh() {
        collectionView?.reloadData()
    }
    
    let photoImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 10
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 5
        return image
    }()

    lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        return button
    }()

    let likeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        return label
    }()

    let captionLabel: UITextView = {
        let text = UITextView()
        text.backgroundColor = UIColor.white
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = UIColor.darkGray
        text.textAlignment = .justified
        text.isScrollEnabled = false
        text.isEditable = false
        return text
    }()

    lazy var taggedButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleGetBookmarkedUser), for: .touchUpInside)
        return button
    }()

    lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    lazy var commentButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.setTitle("Add Comment", for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        
        view.addSubview(self.scrollView)
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)

        self.scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.scrollView.addSubview(locationLabel)
        locationLabel.anchor(top: self.scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.scrollView.addSubview(photoImageView)
        photoImageView.anchor(top: locationLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width)
        
        self.scrollView.addSubview(likeButton)
        self.scrollView.addSubview(captionLabel)
        captionLabel.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: likeButton.leftAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
//        self.scrollView.addSubview(likeButton)
        likeButton.anchor(top: captionLabel.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 30, height: 0)
        
        self.scrollView.addSubview(likeLabel)
        likeLabel.anchor(top: likeButton.bottomAnchor, left: likeButton.leftAnchor, bottom: nil, right: likeButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.scrollView.addSubview(taggedButton)
        taggedButton.anchor(top: captionLabel.bottomAnchor, left: captionLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        self.scrollView.addSubview(commentButton)
        commentButton.anchor(top: taggedButton.bottomAnchor, left: captionLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 25, width: 0, height: 25)
        
        view.addSubview(collectionView)
        collectionView?.anchor(top: commentButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func didSubmit(for comment: String) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let galleryId = self.gallery?.id ?? ""
        //        let ref = FIRDatabase.database().reference().child(Constants.Comment).child(userId).childByAutoId()
        
        let values = [Constants.Text : comment, Constants.CreationDate: Date().timeIntervalSince1970, Constants.Uid: currentUserId] as [String : Any]
        
        let isValid = comment.count > 0
        
        if isValid == true {
            Database.database().reference().child(Constants.Comment).child(galleryId).childByAutoId().updateChildValues(values) { (err, ref) in
                
                if let err = err {
                    print("Failed to insert comment:", err)
                    return
                }
                
                print("Successfully inserted comment.")
            }
        }
        self.containerView.isHidden = true
        self.containerView.clearCommentTextField()
    }
    
    lazy var containerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()
    
    @objc func handleComment() {
        if containerView.isHidden == false {
            containerView.isHidden = true
        } else if containerView.isHidden == true {
            containerView.isHidden = false
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.containerView.endEditing(true)
        return true
    }

    @objc func handleEdit() {
        let alertController = UIAlertController(title: "Please Choose an Action", message: "Delete Event or Edit Event", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            let uid = Auth.auth().currentUser?.uid
            let galleryId = self.gallery?.id
            Database.database().reference().child(Constants.Gallery).child(uid!).child(galleryId!).removeValue()
            let homeVC = HomeVC(collectionViewLayout: UICollectionViewFlowLayout())
            homeVC.user = self.user
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        alertController.addAction(destroyAction)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { action in
            let editPhotoVC = EditPhotoVC()
            editPhotoVC.gallery = self.gallery
            self.navigationController?.pushViewController(editPhotoVC, animated: true)
        }
        alertController.addAction(editAction)
        
        self.present(alertController, animated: true) {
        }
    }
    
    @objc func handleGetBookmarkedUser() {
        let user = gallery?.BookmarkedUser
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.userId = user
        self.navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func getBookmarkedUser() {
        let uid = gallery?.BookmarkedUser
        if uid != "" {
            Database.fetchUserWithUID(uid: uid!) { (user) in
                self.user = user
                self.taggedButton.setTitle("@\(user.username)",for: .normal)
            }
        }
    }
    
    func setupLikeButton() {
        let getUid = self.gallery?.user.uid
        let getId = self.gallery?.id
        let uid = Auth.auth().currentUser?.uid ?? ""
        Database.fetchUserWithUID(uid: uid) { (user) in
            Database.database().reference().child(Constants.Gallery).child(getUid!).child(getId!).child(Constants.Likes).child(uid).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.exists() {
                    self.gallery?.hasLiked = !(self.gallery?.hasLiked)!
                }
            }
        }
    }
    
    func observeLikeCount(withPostId id: String, completion: @escaping (Int, UInt) -> Void) {
        let getUid = self.gallery?.user.uid
        let galleryId = self.gallery?.id
        var likeHandler: UInt!
        likeHandler = Database.database().reference().child(Constants.Gallery).child(getUid!).child(galleryId!).observe(.childChanged, with: {
            snapshot in
            if let value = snapshot.value as? Int {
                completion(value, likeHandler)
            }
        })
    }
    
    func updateLikeCount() {
        self.observeLikeCount(withPostId: (self.gallery?.id)!) { (Int, UInt) in
            self.likeLabel.text = "\(Int)"
        }
    }
    
    @objc func handleLike() {
        let getUid = self.gallery?.user.uid
        guard let galleryId = self.gallery?.id else { return }
        let ref = Database.database().reference()
        let postRef = Database.database().reference().child(Constants.Gallery).child(getUid!).child(galleryId)
        postRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var post = currentData.value as? [String : AnyObject], let uid = self.currentUser?.uid {
                var likes: Dictionary<String, Bool>
                likes = post[Constants.Likes] as? [String : Bool] ?? [:]
                var likeCount = post[Constants.LikeCount] as? Int ?? 0
                if let _ = likes[uid] {
                    likeCount -= 1
                    likes.removeValue(forKey: uid)
                } else {
                    likeCount += 1
                    likes[uid] = true
                }
                post[Constants.LikeCount] = likeCount as AnyObject?
                post[Constants.Likes] = likes as AnyObject?
                currentData.value = post
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error)
            }
        }
        if gallery?.hasLiked == nil {

        } else {
            gallery?.hasLiked = !(gallery?.hasLiked)!
        }
        updateLikeCount()
        ref.removeAllObservers()
    }
    //MARK: Comments
    var comments = [Comment]()
    fileprivate func fetchComments() {
            guard let galleryId = self.gallery?.id else { return }
        let ref = Database.database().reference().child(Constants.Comment).child(galleryId)
        ref.observe(.childAdded, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary[Constants.Uid] as? String else { return }

            Database.fetchUserWithUID(uid: uid, completion: { (user) in

                    let comment = Comment(user: user, dictionary: dictionary)
                    self.comments.append(comment)

                    self.comments.sort(by: { (comment1, comment2) -> Bool in
                        return comment1.creationDate?.compare(comment2.creationDate!) == .orderedDescending
                    })

                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }

                })
                
            }) { (err) in
                print("Failed to observe comments")
            }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentCell
        cell.comment = self.comments[indexPath.item]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        dummyCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        
        let height = max(2, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comment = comments[indexPath.row]
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.userId = comment.user.uid
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
}
