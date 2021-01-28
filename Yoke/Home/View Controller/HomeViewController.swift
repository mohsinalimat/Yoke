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

class HomeViewController: UIViewController {

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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitleAndBarButtonItems()
        setupBannerView()
        setupCollectionView()
        fetchUser()
        fetchMenus()
    }
    
    //MARK: Helper Functions
    
    func setupBannerView() {
        //check if user has a banner image. If no then hide the cover image view
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(bannerImageView)
        view.addSubview(bannerLayerImageView)
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(viewProfileButton)
        view.addSubview(collectionViewBG)
        view.addSubview(menuViewBG)
        view.addSubview(menuLabel)
        view.addSubview(addMenuButton)
        view.addSubview(collectionView)
        constrainViews()
    }
    
    func constrainViews() {
        bannerLayerImageView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: -100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)

        bannerImageView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: -100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)
        
        profileImageView.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
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
        stackView.anchor(top: viewProfileButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 60)
        
        collectionViewBG.anchor(top: stackView.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        menuViewBG.anchor(top: collectionViewBG.topAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: collectionViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 50)
        
        menuLabel.anchor(top: menuViewBG.topAnchor, left: menuViewBG.leftAnchor, bottom: menuViewBG.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        
        addMenuButton.anchor(top: menuViewBG.topAnchor, left: nil, bottom: menuViewBG.bottomAnchor, right: menuViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)

        collectionView.anchor(top: menuViewBG.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: collectionViewBG.bottomAnchor, right: collectionViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
    }
    
    func setupCollectionView() {
//        collectionView.roundCorners([.topLeft,.topRight], radius: 5)
        collectionView.backgroundColor = UIColor.LightGrayBg()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MenuHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
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
            let imageStorageRef = Storage.storage().reference().child("profileImageUrl/\(uid)")
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if error == nil, let data = data {
                    self.profileImageView.image = UIImage(data: data)
                }
            }
            
            let bannerStorageRef = Storage.storage().reference().child("profileBannerUrl/\(uid)")
            bannerStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if error == nil, let data = data {
                    self.bannerImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    fileprivate func fetchMenus() {
        MenuController.shared.fetchMenuWith(uid: Auth.auth().currentUser?.uid ?? "") { (result) in
            switch result {
            case true:
                print("got em")
                self.collectionView.reloadData()
            case false:
                print("nope")
            }
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
        present(editProfile, animated: true)
//        navigationController?.pushViewController(editProfile, animated: true)
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
    
//    @objc func editDeleteGallery(sender: UIButton){
//
//        let alertController = UIAlertController(title: "Please Choose an Action", message: "Delete Event or Edit Event", preferredStyle: .actionSheet)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
//        }
//
//        alertController.addAction(cancelAction)
//
//        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
//            let item = sender.tag
//            let indexPath = IndexPath(item: item, section: 0)
//            let uid = Auth.auth().currentUser?.uid
//            Database.database().reference().child(Constants.Gallery).child(uid!).child(self.galleries[indexPath.item].id!).removeValue()
//            self.galleries.remove(at: item)
//            DispatchQueue.main.async {
//                self.collectionView.deleteItems(at: [indexPath])
//                self.collectionView.reloadData()
//            }
//        }
//        alertController.addAction(destroyAction)
//
//        let editAction = UIAlertAction(title: "Edit", style: .default) { action in
//            let item = sender.tag
//            let indexPath = IndexPath(item: item, section: 0)
//            let gallery = self.galleries[indexPath.row]
//            let editPhotoVC = EditPhotoVC()
//            editPhotoVC.gallery = gallery
//            self.navigationController?.pushViewController(editPhotoVC, animated: true)
//
//        }
//        alertController.addAction(editAction)
//
//        self.present(alertController, animated: true) {
//        }
//    }
    
    @objc func handleAddMenu() {
        let addMenu = AddMenuViewController()
        present(addMenu, animated: true)
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
    let bannerImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .white
        image.image = UIImage(named: "image_background")
        return image
    }()
    
    let bannerLayerImageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.opacity = 0.1
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
//        button.setImage(UIImage(named: "reviews"), for: .normal)
        let image = UIImage(named: "reviews")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Reviews", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 45,bottom: 20,right: 0)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 20,left: -25,bottom: 0,right: 0)
//        button.addTarget(self, action: #selector(handleReviews), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var EventButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "event_full"), for: .normal)
        let image = UIImage(named: "event_full")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Events", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.addTarget(self, action: #selector(handleEvents), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var calendarButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "calendar"), for: .normal)
        let image = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Calendar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.addTarget(self, action: #selector(handleCalendar), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "bookmark_selected"), for: .normal)
        let image = UIImage(named: "bookmark_selected")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Bookmarked", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.addTarget(self, action: #selector(handleBookmarked), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var addPhotosButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "add_image"), for: .normal)
        let image = UIImage(named: "add_image")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.white, for: .normal)
//        button.addTarget(self, action: #selector(handleAddPhotos), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    let collectionViewBG: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let menuViewBG: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        return view
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "Menus"
        label.textColor = UIColor.orangeColor()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var addMenuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add Menu", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleAddMenu), for: .touchUpInside)
        return button
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
        print("menu count \(MenuController.shared.menus.count)")
        if MenuController.shared.menus.count == 0 {
            return 1
        } else {
            return MenuController.shared.menus.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if MenuController.shared.menus.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "Coming Soon"
            noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 13)
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCollectionViewCell
        cell.menu = MenuController.shared.menus[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if MenuController.shared.menus.count == 0 {
            return CGSize(width: collectionView.frame.width - 200, height: 150)
        } else {
            return CGSize(width: view.frame.width / 2, height: 250)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if MenuController.shared.menus.count == 0 {
            return
        } else {
            let menu = MenuController.shared.menus[indexPath.row].id
            print(menu)
//            let galleryDetail = GalleryDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
//            galleryDetail.gallery = gallery
//            navigationController?.pushViewController(galleryDetail, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! MenuHeaderCollectionViewCell
//        header.frame = CGRect(x: 0, y: 0, width: collectionView.frame.width, height: 45)
//        header.menuLabel.text = "Menus"
//        header.backgroundColor = .white
//        header.layer.cornerRadius = 5
//        header.delegate = self
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 100, height: 45)
//    }
}

//extension HomeViewController: MenuHeaderDelegate {
//    func addMenu(_ sender: MenuHeaderCollectionViewCell) {
//        let addMenu = AddMenuViewController()
//        present(addMenu, animated: true)
//    }
//}


