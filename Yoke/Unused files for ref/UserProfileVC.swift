//
//  UserProfileVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class UserProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    let noCellId = "noCellId"
    let cellId = "cellId"
    let headerId = "headerId"
    
    var userId: String?
    var user: User?
    var gallery: Gallery?
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.fetchAllPhotos()
            self.collectionView?.reloadData()
        }
    }
    
    var users = [User]()
    func getUserInfo() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.database().reference().child(Constants.Users).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
//            let user = User(uid: uid, dictionary: userDictionary)
//            print("get username \(user.username)")
//            self.users.append(user)
            self.collectionView.reloadData()
        }) { (err) in
            print("Failed to fetch user:", err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(GalleryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        collectionView?.contentInset = UIEdgeInsets(top: -65, left: 0, bottom: 0, right: 0)
        fetchUser()
        setupNavTitleAndBarButtonItems()
//        getUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    fileprivate func fetchAllPhotos() {
        galleries.removeAll()
        fetchGallery()
    }
    
    func setupNavTitleAndBarButtonItems() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.black

    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleBack() {
        print("dismisse")
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.dismiss(animated: true, completion: nil)
    }
    
    var galleries = [Gallery]()
    fileprivate func fetchGallery() {
        guard let uid = self.user?.uid else {return}
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }

    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child(Constants.Gallery).child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            guard let user = self.user else { return }
            
//            let gallery = Gallery(user: user, dictionary: dictionary)
//            
//            self.galleries.insert(gallery, at: 0)
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if galleries.count == 0 {
            return 1
        } else {
            return galleries.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if galleries.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "No Posts Yet"
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GalleryCell
        //        cell.delegate = self
        cell.backgroundColor = UIColor.white
        cell.gallery = galleries[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if galleries.count == 0 {
            return CGSize(width: view.frame.width, height: 200)
        } else {
            let width = (view.frame.width - 2) / 2
            return CGSize(width: width, height: width)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if galleries.count == 0 {
            return
        } else {
            let gallery = galleries[indexPath.row]
            let galleryDetail = GalleryDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
            galleryDetail.gallery = gallery
            navigationController?.pushViewController(galleryDetail, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserHeaderCell

        header.user = self.user
        header.delegate = self
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if let statusText = user?.aboutUser {
//            
//            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 14)], context: nil)
//            
//            if user?.aboutUser == "" && user?.isChef == true {
//                let knownHeight: CGFloat = 335 + 120
//                return CGSize(width: view.frame.width, height: knownHeight)
//            } else if user?.isChef == false && user?.aboutUser == "" {
//                let knownHeight: CGFloat = 380
//                return CGSize(width: view.frame.width, height: knownHeight)
//            }
//
//            let knownHeight: CGFloat = 335
//            return CGSize(width: view.frame.width, height: knownHeight + rect.height + 120)
//        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    //MARK: Functions
    func sendMessage(user: User) {
        let requestVC = RequestFormVC()
        requestVC.user = user
        navigationController?.pushViewController(requestVC, animated: true)
    }
    
    func viewReviews(user: User) {
        let reviewsVC = ReviewsVC(collectionViewLayout: UICollectionViewFlowLayout())
        reviewsVC.user = user
        navigationController?.pushViewController(reviewsVC, animated: true)
    }
    
    func viewEvents(user: User) {
//        let userEventVC = UserEventVC(collectionViewLayout: UICollectionViewFlowLayout())
//        userEventVC.user = user
//        navigationController?.pushViewController(userEventVC, animated: true)
    }
    
    @objc func handleUserCalendar() {
        //        let userCalendarVC = UserCalendarVC()
        //        userCalendarVC.user = user
        //        navigationController?.pushViewController(userCalendarVC, animated: true)
    }
    
    //    func viewBookmarkedUserProfile(for cell: GalleryCell) {
    //        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
    //        let gallery = self.galleries[indexPath.item]
    //        guard let uid = gallery.BookmarkedUser else {return}
    //        if uid == "" {
    //            cell.savedWithButton.isHidden = true
    //        } else {
    //            FIRDatabase.fetchUserWithUID(uid: uid) { (user) in
    //                self.user = user
    //                let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
    //                userProfileVC.userId = user.uid
    //                self.navigationController?.pushViewController(userProfileVC, animated: true)
    //            }
    //
    //            FIRDatabase.fetchChefWithUID(uid: uid) { (user) in
    //                self.user = user
    //                let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
    //                userProfileVC.userId = user.uid
    //                self.navigationController?.pushViewController(userProfileVC, animated: true)
    //            }
    //        }
    //    }
    
}
