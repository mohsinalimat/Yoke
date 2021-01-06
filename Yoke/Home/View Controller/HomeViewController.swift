//
//  HomeViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/5/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HomeViewController: UIViewController, HomeProfileHeaderDelegate {

    //MARK: Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let noCellId = "noCellId"
    let cellId = "cellId"
    let headerId = "headerId"
    var userId: String?
    var galleries = [Gallery]()
    var user = [User]()
    var users = [User]()
    
    //MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitleAndBarButtonItems()
        setupCollectionView()
        setupViews()
        fetchUser()
    }
    
    //MARK: Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(coverImageView)
        view.addSubview(bannerImageCover)
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(viewProfileButton)
        view.addSubview(menuLabel)
        view.addSubview(collectionView)
        constrainViews()
    }
    
    func constrainViews() {
        bannerImageCover.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: -100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 330)

        coverImageView.anchor(top: bannerImageCover.topAnchor, left: bannerImageCover.leftAnchor, bottom: bannerImageCover.bottomAnchor, right: bannerImageCover.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        profileImageView.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 50
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)

        viewProfileButton.anchor(top: usernameLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 45)
//
        setupBottomToolbar()
    }
    
    fileprivate func setupBottomToolbar() {
        reviewsButton.alignImageTextVertical()
        EventButton.alignImageTextVertical()
        bookmarkButton.alignImageTextVertical()
        addPhotosButton.alignImageTextVertical()
        calendarButton.alignImageTextVertical()

        let stackView = UIStackView(arrangedSubviews: [reviewsButton, EventButton, addPhotosButton, bookmarkButton, calendarButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        view.addSubview(stackView)
        stackView.anchor(top: viewProfileButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 60)
        
        menuLabel.anchor(top: stackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 45)
        
        collectionView.anchor(top: menuLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        collectionView.contentInset = UIEdgeInsets(top: -80, left: 0, bottom: 0, right: 0)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.LightGrayBg()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
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
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username else { return }
            self.usernameLabel.text = "Welcome back \(username)"
//            self.fetchPostsWithUser(user: user)
        }
    }

    fileprivate func fetchPostsWithUser(user: User) {
        GalleryController.shared.fetchGalleryWith(user: user) { (result) in
            switch result {
            case true:
                print("Result: fetched")
                self.collectionView.reloadData()
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
        let editProfile = SettingsViewController()
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
                self.collectionView.deleteItems(at: [indexPath])
                self.collectionView.reloadData()
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
    
    //MARK: - Views
    let coverImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "foodBackground")
        return image
    }()
    
    let bannerImageCover: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.opacity = 0.4
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.image = UIImage(named: "person.crop.circle.fill")
        image.tintColor = UIColor.orangeColor()
        image.backgroundColor = .white
        image.layer.borderWidth = 2
        return image
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let ratingView: RatingView = {
        let view = RatingView()
        view.backgroundColor = .clear
        view.minRating = 0
        view.maxRating = 5
        view.rating = 2.5
        view.editable = false
        view.emptyImage = UIImage(named: "star_unselected_color")
        view.fullImage = UIImage(named: "star_selected_color")
        return view
    }()
    
    lazy var viewProfileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("View Profile", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
//        button.addTarget(self, action: #selector(handleViewProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var reviewsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "reviews"), for: .normal)
        button.setTitle("Reviews", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 45,bottom: 20,right: 0)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 20,left: -25,bottom: 0,right: 0)
//        button.addTarget(self, action: #selector(handleReviews), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var EventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "event_full"), for: .normal)
        button.setTitle("Events", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
//        button.addTarget(self, action: #selector(handleEvents), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var calendarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "calendar"), for: .normal)
        button.setTitle("Calendar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
//        button.addTarget(self, action: #selector(handleCalendar), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bookmark_selected"), for: .normal)
        button.setTitle("Bookmarked", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
//        button.addTarget(self, action: #selector(handleBookmarked), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var addPhotosButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add_image"), for: .normal)
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.darkGray, for: .normal)
//        button.addTarget(self, action: #selector(handleAddPhotos), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "Menus"
//        label.backgroundColor = UIColor.orangeColor()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.textColor = UIColor.orangeColor()
//        label.backgroundColor = .white
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
}

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(galleries.count)
        if galleries.count == 0 {
            return 1
        } else {
            return galleries.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if galleries.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "Menu Coming Soon"
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! GalleryCell
        cell.gallery = galleries[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if galleries.count == 0 {
            return CGSize(width: view.frame.width, height: 200)
        } else {
            let width = (view.frame.width - 2) / 2
//            let width = view.frame.width
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
}
