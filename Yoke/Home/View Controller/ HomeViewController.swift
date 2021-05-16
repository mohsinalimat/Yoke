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
    let menuCell = "menuCell"
    let chefCell = "chefCell"
    let bookingCell = "bookingCell"
    let eventCell = "eventCell"
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
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchUser()
        fetchMenus()
        fetchSuggestedChefs()
        fetchEvents()
    }
    
    //MARK: Helper Functions
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.alwaysBounceHorizontal = true
        scrollView.bounces = true
        scrollView.addSubview(bannerLayerView)
        scrollView.addSubview(backgroundView)
        scrollView.addSubview(profileImageShadowView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(viewProfileButton)
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(reviewsButton)
        buttonStackView.addArrangedSubview(eventButton)
        buttonStackView.addArrangedSubview(bookmarkButton)
        buttonStackView.addArrangedSubview(bookingButton)
        scrollView.addSubview(collectionViewBG)
        scrollView.addSubview(menuChefLabel)
        scrollView.addSubview(addMenuButton)
        scrollView.addSubview(menuCollectionView)
        scrollView.addSubview(suggestedChefCollectionView)
        scrollView.addSubview(bookingsEventLabel)
        scrollView.addSubview(eventsNearYouCollectionView)
        scrollView.addSubview(upcomingBookingsCollectionView)
    }
    
    func constrainViews() {
        let totalHeight = view.frame.height + 175
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        bannerLayerView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 200)
        backgroundView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 200)
        profileImageShadowView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        profileImageShadowView.layer.cornerRadius = 150 / 2
        profileImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 30, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        profileImageView.layer.cornerRadius = 150 / 2
        
        usernameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 5)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        viewProfileButton.anchor(top: usernameLabel.bottomAnchor, left: usernameLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        toobarSetup()
    }
    
    func toobarSetup() {
        reviewsButton.alignImageTextVertical()
        eventButton.alignImageTextVertical()
        bookmarkButton.alignImageTextVertical()
        bookingButton.alignImageTextVertical()
        
        buttonStackView.anchor(top: backgroundView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 60)
        
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            if user.isChef == false {
                self.setupBottomToolbarUser()
                self.eventButton.isHidden = true
                self.bookingButton.isHidden = true
            } else {
                self.setupBottomToolbarChef()
                self.eventButton.isHidden = false
                self.bookingButton.isHidden = false
            }
        }
    }
    
    fileprivate func setupBottomToolbarChef() {
        collectionViewBG.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: scrollView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        
        menuChefLabel.anchor(top: collectionViewBG.topAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        addMenuButton.anchor(top: menuChefLabel.topAnchor, left: nil, bottom: nil, right: collectionViewBG.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10)
        
        menuCollectionView.anchor(top: menuChefLabel.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: collectionViewBG.rightAnchor, paddingTop: -10, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 175)
        
        bookingsEventLabel.anchor(top:  menuCollectionView.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        upcomingBookingsCollectionView.anchor(top: bookingsEventLabel.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: collectionViewBG.bottomAnchor, right: collectionViewBG.rightAnchor, paddingTop: -10, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 180)
    }
    
    fileprivate func setupBottomToolbarUser() {
        collectionViewBG.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: scrollView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        
        menuChefLabel.anchor(top: collectionViewBG.topAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        suggestedChefCollectionView.anchor(top: menuChefLabel.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: collectionViewBG.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 220)
        
        bookingsEventLabel.anchor(top:  suggestedChefCollectionView.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        eventsNearYouCollectionView.anchor(top: bookingsEventLabel.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: collectionViewBG.bottomAnchor, right: collectionViewBG.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 220)
    }
    
    func setupCollectionView() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let chef = user.isChef else { return }
            self.isChef = chef
            if self.isChef == true {
                self.suggestedChefCollectionView.isHidden = true
                self.eventsNearYouCollectionView.isHidden = true
                self.menuCollectionView.isHidden = false
                self.upcomingBookingsCollectionView.isHidden = false
                self.addMenuButton.isHidden = false
                self.menuChefLabel.text = "Menus"
                self.bookingsEventLabel.text = "Upcoming"
            } else {
                self.suggestedChefCollectionView.isHidden = false
                self.eventsNearYouCollectionView.isHidden = false
                self.menuCollectionView.isHidden = true
                self.upcomingBookingsCollectionView.isHidden = true
                self.addMenuButton.isHidden = true
                self.menuChefLabel.text = "Chef's near you"
                self.bookingsEventLabel.text = "Events near you"
            }
        }
        
        menuCollectionView.backgroundColor = UIColor.clear
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: menuCell)
        menuCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        
        suggestedChefCollectionView.backgroundColor = UIColor.clear
        suggestedChefCollectionView.delegate = self
        suggestedChefCollectionView.dataSource = self
        suggestedChefCollectionView.translatesAutoresizingMaskIntoConstraints = false
        suggestedChefCollectionView.register(SuggestedChefsCollectionViewCell.self, forCellWithReuseIdentifier: chefCell)
        suggestedChefCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        
        upcomingBookingsCollectionView.backgroundColor = UIColor.clear
        upcomingBookingsCollectionView.delegate = self
        upcomingBookingsCollectionView.dataSource = self
        upcomingBookingsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        upcomingBookingsCollectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: bookingCell)
        upcomingBookingsCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        
        eventsNearYouCollectionView.backgroundColor = UIColor.clear
        eventsNearYouCollectionView.delegate = self
        eventsNearYouCollectionView.dataSource = self
        eventsNearYouCollectionView.translatesAutoresizingMaskIntoConstraints = false
        eventsNearYouCollectionView.register(SuggestedEventsCollectionViewCell.self, forCellWithReuseIdentifier: eventCell)
        eventsNearYouCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    func configureNavigationBar() {
        let icon = UIImage(named: "menu")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        imageView.image = icon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(handleSettings))
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Home", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func handleUpdateObserverAndRefresh() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdate), name: SettingsViewController.updateNotificationName, object: nil)
    }
    
    //MARK: - API
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username else { return }
            self.usernameLabel.text = "Hey, \(username)"
            let imageStorageRef = Storage.storage().reference().child("profileImageUrl/\(uid)")
            imageStorageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
                if error == nil, let data = data {
                    self.profileImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
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
    
    func fetchEvents() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { user in
            guard let latitude = user.latitude,
                  let longitude = user.longitude else { return }
            EventController.shared.fetchSuggestedEventsWith(latitude: latitude, longitude: longitude) { result in
                switch result {
                default:
                    DispatchQueue.main.async {
                        self.eventsNearYouCollectionView.reloadData()
                    }
                }
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
        let reviewsVC = ReviewsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        reviewsVC.userId = userId
        navigationController?.pushViewController(reviewsVC, animated: true)
    }
    
    @objc func viewEvents() {
        let eventsVC = ChefsEventsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        eventsVC.userId = userId
        navigationController?.pushViewController(eventsVC, animated: true)
    }
    
    @objc func viewBookings() {
        let bookingsVC = BookingsViewController()
        navigationController?.pushViewController(bookingsVC, animated: true)
    }
    
    @objc func handleSettings() {
        let editProfile = SettingsViewController()
        present(editProfile, animated: true)
    }
    
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
        view.backgroundColor = UIColor.LightGrayBg()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bannerLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    var backgroundView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 10
        image.backgroundColor = .clear
        image.image = UIImage(named: "gradientBackgroundHalf")
        return image
    }()
    
    let profileImageShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.white.cgColor
        image.image = UIImage(named: "person.crop.circle.fill")
        image.backgroundColor = .white
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    lazy var viewProfileButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("View Profile", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(handleViewProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var reviewsButton: UIButton = {
        let button = UIButton(type: .custom)
        //        button.setImage(UIImage(named: "reviews"), for: .normal)
        let image = UIImage(named: "reviews")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.orangeColor()
        button.setTitle("Reviews", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0,left: 45,bottom: 20,right: 0)
        button.titleEdgeInsets = UIEdgeInsets.init(top: 20,left: -25,bottom: 0,right: 0)
        button.addTarget(self, action: #selector(viewReviews), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var eventButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "event_full")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.orangeColor()
        button.setTitle("Events", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(viewEvents), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var bookingButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.orangeColor()
        button.setTitle("Bookings", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(viewBookings), for: .touchUpInside)
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "bookmark_selected")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.orangeColor()
        button.setTitle("Bookmarked", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        stackView.layer.shadowRadius = 4
        stackView.layer.shadowOpacity = 0.2
        stackView.layer.shadowColor = UIColor.lightGray.cgColor
        return stackView
    }()
    
    let collectionViewBG: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let menuChefLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    let bookingsEventLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 22)
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
    
    let upcomingBookingsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let eventsNearYouCollectionView: UICollectionView = {
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
        } else if collectionView == self.suggestedChefCollectionView {
            if SuggestedChefController.shared.chefs.count == 0 {
                return 1
            } else {
                return SuggestedChefController.shared.chefs.count
            }
        } else if collectionView == self.upcomingBookingsCollectionView {
            return 1
//            if BookingController.shared.bookings.count == 0 {
//                return 1
//            } else {
//                return BookingController.shared.bookings.count
//            }
        }
        if EventController.shared.events.count == 0 {
            return 1
        } else {
            print("Event Count \(EventController.shared.events.count)")
            return EventController.shared.events.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.menuCollectionView {
            if MenuController.shared.menus.count == 0 {
                let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
                noCell.noPostLabel.text = "Hey chef, Add a menu to your profile."
                noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 15)
                return noCell
            }
            
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: menuCell, for: indexPath) as! MenuCollectionViewCell
            cellA.menu = MenuController.shared.menus[indexPath.item]
            return cellA
        } else if collectionView == self.suggestedChefCollectionView {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: chefCell, for: indexPath) as! SuggestedChefsCollectionViewCell
            if SuggestedChefController.shared.chefs.count == 0 {
                let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
                noCell.noPostLabel.text = "Sorry, there are currently no chefs in your area"
                noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 15)
                return noCell
            } else {
                cellB.chef = SuggestedChefController.shared.chefs[indexPath.item]
                return cellB
            }
        } else if collectionView == self.upcomingBookingsCollectionView {
            let cellC = collectionView.dequeueReusableCell(withReuseIdentifier: bookingCell, for: indexPath) as! TodayCollectionViewCell
//            cellC.booking = BookingController.shared.bookings[indexPath.item]
            return cellC
//            if BookingController.shared.bookings.count == 0 {
//                let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
//                noCell.noPostLabel.text = "Sorry, you have no upcoming bookings"
//                noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 15)
//                return noCell
//            } else {
//                cellC.booking = BookingController.shared.bookings[indexPath.item]
//                return cellC
//            }
        }
        
        let cellD = collectionView.dequeueReusableCell(withReuseIdentifier: eventCell, for: indexPath) as! SuggestedEventsCollectionViewCell
        if EventController.shared.events.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.noPostLabel.text = "Sorry, there are currently no events in your area"
            noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 15)
            return noCell
        } else {
            cellD.event = EventController.shared.events[indexPath.item]
            return cellD
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.menuCollectionView {
            if MenuController.shared.menus.count == 0 {
                return CGSize(width: view.frame.width - 20, height: 100)
            } else {
                return CGSize(width: view.frame.width - 20, height: 180)
            }
        } else if collectionView == self.suggestedChefCollectionView {
            if SuggestedChefController.shared.chefs.count == 0 {
                return CGSize(width: view.frame.width - 20, height: 100)
            } else {
                return CGSize(width: view.frame.width / 2 , height: 180)
            }
        } else if collectionView == self.upcomingBookingsCollectionView {
            return CGSize(width: view.frame.width - 20 , height: 150)
//            if SuggestedChefController.shared.chefs.count == 0 {
//                return CGSize(width: view.frame.width - 20, height: 100)
//            } else {
//                return CGSize(width: view.frame.width / 2 , height: 180)
//            }
        }
        return CGSize(width: view.frame.width / 2 , height: 180)
//        if SuggestedChefController.shared.chefs.count == 0 {
//            return CGSize(width: view.frame.width - 20, height: 100)
//        } else {
//            return CGSize(width: view.frame.width / 2 , height: 180)
//        }
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
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 10
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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


