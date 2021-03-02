//
//  HomeViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/5/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class HomeViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let noCellId = "noCellId"
    let cellId = "cellId"
    let headerId = "headerId"
    var userId: String?
    private let refreshControl = UIRefreshControl()
    var isChef: Bool = false
    var user: User?
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleUpdateObserverAndRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavTitleAndBarButtonItems()
        setupBannerView()
        setupCollectionView()
        fetchUser()
        fetchMenus()
        fetchSuggestedChefs()
    }
    
    //MARK: Helper Functions
    
    func setupBannerView() {
        //check if user has a banner image. If no then hide the cover image view
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        scrollView.addSubview(bannerImageView)
        scrollView.addSubview(bannerLayerImageView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(viewProfileButton)
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(reviewsButton)
        buttonStackView.addArrangedSubview(eventButton)
        buttonStackView.addArrangedSubview(addPhotosButton)
        buttonStackView.addArrangedSubview(bookmarkButton)
        buttonStackView.addArrangedSubview(calendarButton)
        scrollView.addSubview(collectionViewBG)
        scrollView.addSubview(menuViewBG)
        scrollView.addSubview(menuLabel)
        scrollView.addSubview(addMenuButton)
        scrollView.addSubview(menuCollectionView)
        scrollView.addSubview(suggestedChefCollectionView)
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refreshControl
        } else {
            scrollView.addSubview(refreshControl)
        }
    }
    
    func constrainViews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 50)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        bannerLayerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)

        bannerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)
        
        profileImageView.anchor(top: scrollView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImageView.layer.cornerRadius = 50
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 45)

        viewProfileButton.anchor(top: usernameLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 40)
        setupBottomToolbar()
    }
    
    fileprivate func setupBottomToolbar() {
        reviewsButton.alignImageTextVertical()
        eventButton.alignImageTextVertical()
        bookmarkButton.alignImageTextVertical()
        addPhotosButton.alignImageTextVertical()
        calendarButton.alignImageTextVertical()

        buttonStackView.anchor(top: viewProfileButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 60)
        
//        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height - 200)
//        scrollView.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        collectionViewBG.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: scrollView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 8, paddingRight: 5, height: view.frame.width - 100)
        
        menuViewBG.anchor(top: collectionViewBG.topAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: collectionViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 50)

        menuLabel.anchor(top: menuViewBG.topAnchor, left: menuViewBG.leftAnchor, bottom: menuViewBG.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)

        addMenuButton.anchor(top: menuViewBG.topAnchor, left: nil, bottom: menuViewBG.bottomAnchor, right: menuViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)

        menuCollectionView.anchor(top: menuViewBG.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: collectionViewBG.bottomAnchor, right: collectionViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        
        suggestedChefCollectionView.anchor(top: menuViewBG.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: collectionViewBG.bottomAnchor, right: collectionViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
    }
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        let firestoreDB = Firestore.firestore()
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            firestoreDB.collection(Constants.Users).document(uid).collection(Constants.Ratings).getDocuments { (snap, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                var totalVotes = 0
                for doc in snap!.documents {
                   if let rate = doc.data() as? Int {
                      totalVotes += rate
                   }
                }
                print("vote \(totalVotes)")
            }
            guard let username = user.username else { return }
            self.usernameLabel.text = "WELCOME BACK \(username)"
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
    
    func setupCollectionView() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let chef = user.isChef else { return }
            self.isChef = chef
            if self.isChef == true {
                self.suggestedChefCollectionView.isHidden = true
                self.menuCollectionView.isHidden = false
                self.addMenuButton.isHidden = false
                self.menuLabel.text = "Menus"
            } else {
                self.suggestedChefCollectionView.isHidden = false
                self.menuCollectionView.isHidden = true
                self.addMenuButton.isHidden = true
                self.menuLabel.text = "Chef's near you"
            }
        }
        
        menuCollectionView.backgroundColor = UIColor.LightGrayBg()
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        menuCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        
        suggestedChefCollectionView.backgroundColor = UIColor.LightGrayBg()
        suggestedChefCollectionView.delegate = self
        suggestedChefCollectionView.dataSource = self
        suggestedChefCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(MenuHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        suggestedChefCollectionView.register(SuggestedChefsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        suggestedChefCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    func setupNavTitleAndBarButtonItems() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.black
        let icon = UIImage(named: "menu")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        imageView.image = icon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(handleSettings))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleSettings))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        
    }
    
    func handleUpdateObserverAndRefresh() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdate), name: SettingsViewController.updateNotificationName, object: nil)
    }

    //MARK: - API
    fileprivate func fetchSuggestedChefs() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let latitude = user.latitude,
                  let longitude = user.longitude else { return }
            SuggestedChefController.shared.fetchSuggestedChefsWith(uid: uid, latitude: latitude, longitude: longitude) { (result) in
                switch result {
                case true:
                    DispatchQueue.main.async {
                        self.suggestedChefCollectionView.reloadData()
                    }
                case false:
                    print("failed to fetch any chefs in your area")
                }
            }
        }
    }
    
    fileprivate func fetchMenus() {
        MenuController.shared.fetchMenuWith(uid: Auth.auth().currentUser?.uid ?? "") { (result) in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.menuCollectionView.reloadData()
                }
            case false:
                print("Problem Loading Menus")
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleUpdate() {
        DispatchQueue.main.async {
            self.fetchUser()
            self.setupCollectionView()
        }
    }
    
    @objc func viewReviews() {
        let reviewsVC = NewReviewVC()
        reviewsVC.userId = userId
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
//        let profileView = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
//        profileView.user = user
//        navigationController?.pushViewController(profileView, animated: true)
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
    
    @objc func handleViewProfile() {
        let profileView = ProfileViewController()
        profileView.userId = userId
        navigationController?.pushViewController(profileView, animated: true)
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
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        view.layer.opacity = 0.3
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
        button.addTarget(self, action: #selector(handleViewProfile), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(viewReviews), for: .touchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 8
        return button
    }()
    
    lazy var eventButton: UIButton = {
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
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        return stackView
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

    let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let suggestedChefCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
}

// MARK: - CollectionView
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.menuCollectionView {
            if MenuController.shared.menus.count == 0 {
                return 1
            } else {
                return MenuController.shared.menus.count
            }
        }
        if SuggestedChefController.shared.chefs.count == 0 {
            return 1
        } else {
            return SuggestedChefController.shared.chefs.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.menuCollectionView {
            if MenuController.shared.menus.count == 0 {
                let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
                noCell.photoImageView.image = UIImage(named: "no_post_background")!
                noCell.noPostLabel.text = "Hey there chef, Let's add a menu item to your profile."
                noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 17)
                return noCell
            }
            
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCollectionViewCell
            cellA.menu = MenuController.shared.menus[indexPath.item]
            return cellA
        }

        let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SuggestedChefsCollectionViewCell
        if SuggestedChefController.shared.chefs.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "Sorry, there are currently no chefs in your area"
            noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 17)
            return noCell
        } else {
            cellB.chef = SuggestedChefController.shared.chefs[indexPath.item]
            return cellB
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.menuCollectionView {
            if MenuController.shared.menus.count == 0 {
                return CGSize(width: view.frame.width - 20, height: 200)
            } else {
                return CGSize(width: view.frame.width - 20, height: 180)
//                return CGSize(width: view.frame.width / 2, height: 200)
            }
        }
        
        if SuggestedChefController.shared.chefs.count == 0 {
            return CGSize(width: view.frame.width - 20, height: 200)
        } else {
            return CGSize(width: 150, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.menuCollectionView {
            if MenuController.shared.menus.count == 0 {
                return
            } else {
                let menu = MenuController.shared.menus[indexPath.row]
                let menuVC = AddMenuViewController()
                menuVC.menu = menu
                menuVC.menuLabel.text = "Edit Menu"
                menuVC.dishDetailTextField.placeholder = ""
                menuVC.deleteButton.isHidden = false
                menuVC.menuExist = true
                menuVC.saveButton.setTitle("Update", for: .normal)
                present(menuVC, animated: true)
            }
        } else {
            if SuggestedChefController.shared.chefs.count == 0 {
                return
            } else {
                let chef = SuggestedChefController.shared.chefs[indexPath.row].uid
                let profileVC = ProfileViewController()
                profileVC.userId = chef
                navigationController?.pushViewController(profileVC, animated: true)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
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


