//
//  HomeVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomeProfileHeaderDelegate {

    //MARK: - Properties
    let noCellId = "noCellId"
    let cellId = "cellId"
    let headerId = "headerId"
    let homePostCellId = "homePostCellId"
    var userId: String?
    var user: User?
    var gallery: Gallery?
    
    //MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavTitleAndBarButtonItems()
        fetchUser()
        fetchGallery()
    }
    
    //MARK: - Helper Functions
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.fetchPostsWithUser(user: user)
        }
    }
    
//    fileprivate func fetchUserPhotos() {
//        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
//        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
//            self.user = user
//            DispatchQueue.main.async {
//                self.fetchGallery()
//                self.collectionView.reloadData()
//            }
//        }
//    }
    
    func handleUpdatesForProfile() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdates), name: SharePhotoVC.updateNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdates), name: EditProfileVC.updateNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdates), name: CustomCoverImageVC.updateNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdates), name: ChefPreferencesVC.updateNotificationName, object: nil)
    }
    
    func setupNavTitleAndBarButtonItems() {
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.view.backgroundColor = UIColor.black
        let icon = UIImage(named: "menu")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        imageView.image = icon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(handleSettings))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        
    }
    
    func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(HomeHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(GalleryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        collectionView?.contentInset = UIEdgeInsets(top: -65, left: 0, bottom: 0, right: 0)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    
    var galleries = [Gallery]()
    fileprivate func fetchGallery() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User) {
        GalleryController.shared.fetchGalleryWith(user: user) { (result) in
            switch result {
            case true:
                print("Result: fetched")
            case false:
                print("Result: not fetched")
            }
        }
//        let ref = Database.database().reference().child(Constants.Gallery).child(uid)
//
//        ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//
//            guard let user = self.user else { return }
            
//            let gallery = Gallery(imageUrl: <#T##String#>, caption: <#T##String#>, location: <#T##String#>, likes: <#T##Dictionary<String, Any>#>, likeCount: <#T##Int#>, isLiked: <#T##Bool#>, creationDate: <#T##Date#>)
            
//            self.galleries.insert(gallery, at: 0)
//            self.collectionView?.reloadData()
            
//        }) { (err) in
//            print("Failed to fetch ordered posts:", err)
//        }
        
    }
    
    @objc func handleLogOut() {
        do {
            try Auth.auth().signOut()
            UIView.animate(withDuration: 0.5) { [weak self] in
                let loginVC = LoginVC()
                self?.view.window?.rootViewController = loginVC
                self?.view.window?.makeKeyAndVisible()
            }
        } catch let signOutErr {
            print("Failed to sign out:", signOutErr)
        }
    }
    
    @objc func handleUpdates() {
        fetchUser()
    }
    
    @objc func handleLoad() {
        DispatchQueue.main.async {
            self.fetchGallery()
            self.collectionView.reloadData()
        }
    }
    
    @objc func handleRefresh() {
        self.galleries.removeAll()
        fetchGallery()
        collectionView?.reloadData()
        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl?.endRefreshing()
        } else {
            
        }
    }

    func viewReviews(user: User) {
        let reviewsVC = ReviewsVC(collectionViewLayout: UICollectionViewFlowLayout())
        reviewsVC.user = user
        navigationController?.pushViewController(reviewsVC, animated: true)
    }
    
    func viewEvents(user: User) {
        let editEventVC = EditEventVC(collectionViewLayout: UICollectionViewFlowLayout())
        editEventVC.user = user
        navigationController?.pushViewController(editEventVC, animated: true)
    }
    
    func addPhotos(user: User) {
//        let addPhotosVC = AddPhotoVC(collectionViewLayout: UICollectionViewFlowLayout())
        let addPhotosVC = AddPhotoVC()
        addPhotosVC.user = user
        navigationController?.pushViewController(addPhotosVC, animated: true)
    }
    
    func viewCalendar(user: User) {
        let calendarVC = CalendarVC()
        calendarVC.user = user
        navigationController?.pushViewController(calendarVC, animated: true)
    }
    
    @objc func handleSettings() {
        let editProfile = EditProfileVC()
        navigationController?.pushViewController(editProfile, animated: true)
    }
    
    func viewBookmarked(user: User) {
        let bookmarkedVC = BookmarkedVC(collectionViewLayout: UICollectionViewFlowLayout())
        bookmarkedVC.user = user
        navigationController?.pushViewController(bookmarkedVC, animated: true)
    }
    
    func viewProfile(user: User) {
        let profileView = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        profileView.user = user
        navigationController?.pushViewController(profileView, animated: true)
    }
    
    @objc func editDeleteGallery(sender: UIButton){
        
        let alertController = UIAlertController(title: "Please Choose an Action", message: "Delete Event or Edit Event", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            let item = sender.tag
            let indexPath = IndexPath(item: item, section: 0)
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child(Constants.Gallery).child(uid!).child(self.galleries[indexPath.item].id!).removeValue()
            self.galleries.remove(at: item)
            DispatchQueue.main.async {
                self.collectionView?.deleteItems(at: [indexPath])
                self.collectionView?.reloadData()
            }
        }
        alertController.addAction(destroyAction)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { action in
            let item = sender.tag
            let indexPath = IndexPath(item: item, section: 0)
            let gallery = self.galleries[indexPath.row]
            let editPhotoVC = EditPhotoVC()
            editPhotoVC.gallery = gallery
            self.navigationController?.pushViewController(editPhotoVC, animated: true)
            
        }
        alertController.addAction(editAction)
        
        self.present(alertController, animated: true) {
        }
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

extension HomeVC {
    //MARK: - Collection View
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
        cell.gallery = galleries[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if galleries.count == 0 {
            return CGSize(width: view.frame.width, height: 400)
        } else {
//            let width = (view.frame.width - 2) / 2
            let width = view.frame.width
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HomeHeaderCell
        header.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        header.user = self.user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 420)
    }
}
