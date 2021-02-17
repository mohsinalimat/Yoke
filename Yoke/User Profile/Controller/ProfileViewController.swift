//
//  ProfileViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/8/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import TTGTagCollectionView

class ProfileViewController: UIViewController, TTGTextTagCollectionViewDelegate {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var userId: String?
    let cusineCollectionView = TTGTextTagCollectionView()
    let noCellId = "noCellId"
    let cellId = "cellId"
    var user: User? {
        didSet {
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        let userProfileVC = ProfileViewController()
        userProfileVC.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupCollectionView()
    }

    //MARK: - Helper Functions
    func setupButtonImages() {
        reviewsButton.alignImageTextVertical()
        eventButton.alignImageTextVertical()
        bookmarkButton.alignImageTextVertical()
        addPhotosButton.alignImageTextVertical()
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(scrollView)
        scrollView.addSubview(bannerImageView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(ratingView)
        scrollView.addSubview(statsStackView)
        statsStackView.addArrangedSubview(reviewCountLabel)
        statsStackView.addArrangedSubview(rebookCountLabel)
        statsStackView.addArrangedSubview(verifiedLabel)
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(reviewsButton)
        buttonStackView.addArrangedSubview(eventButton)
        buttonStackView.addArrangedSubview(addPhotosButton)
        buttonStackView.addArrangedSubview(bookmarkButton)
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(bioTextLabel)
        scrollView.addSubview(cusineLabel)
        scrollView.addSubview(seperatorView)
        scrollView.addSubview(cusineCollectionView)
        scrollView.addSubview(collectionViewBG)
        scrollView.addSubview(menuViewBG)
        scrollView.addSubview(menuLabel)
        scrollView.addSubview(menuCollectionView)
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            if user.isChef == false {
                self.constrainViewsForUser()
            } else {
                self.constrainViewsForChef()
            }
        }
    }
    
    func constrainViewsForChef() {
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)

        bannerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200)
        
        profileImageView.anchor(top: bannerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        profileImageView.layer.cornerRadius = 75
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        locationLabel.anchor(top: usernameLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        ratingView.anchor(top: locationLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        statsStackView.anchor(top: ratingView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 35)
        
        setupButtonImages()
        buttonStackView.anchor(top: statsStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, height: 50)
        
        bioLabel.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 5)
        
        bioTextLabel.anchor(top: bioLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        
        seperatorView.anchor(top: bioTextLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, height: 0.5)
        
        cusineLabel.anchor(top: seperatorView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0)
        cusineCollectionView.anchor(top: cusineLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 5, height: 45)
        
        collectionViewBG.anchor(top: cusineCollectionView.bottomAnchor, left: safeArea.leftAnchor, bottom: scrollView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 8, paddingRight: 5, height: view.frame.width - 100)
        
        menuViewBG.anchor(top: collectionViewBG.topAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: collectionViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 50)

        menuLabel.anchor(top: menuViewBG.topAnchor, left: menuViewBG.leftAnchor, bottom: menuViewBG.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)

        menuCollectionView.anchor(top: menuViewBG.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: collectionViewBG.bottomAnchor, right: collectionViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
    }
    
    func constrainViewsForUser() {
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)

        bannerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200)
        
        profileImageView.anchor(top: bannerImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: -75, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        profileImageView.layer.cornerRadius = 75
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        locationLabel.anchor(top: usernameLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        ratingView.anchor(top: locationLabel.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 80, height: 20)
        ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        statsStackView.anchor(top: ratingView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, height: 35)
        
        setupButtonImages()
        buttonStackView.anchor(top: statsStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, height: 50)
        
        bioLabel.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 5)
        
        bioTextLabel.anchor(top: bioLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
    }
    
    func setupCollectionView() {
        menuCollectionView.backgroundColor = UIColor.LightGrayBg()
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        menuCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        
//        galleryCollectionView.backgroundColor = UIColor.LightGrayBg()
//        galleryCollectionView.delegate = self
//        galleryCollectionView.dataSource = self
//        galleryCollectionView.translatesAutoresizingMaskIntoConstraints = false
////        collectionView.register(MenuHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//        galleryCollectionView.register(SuggestedChefsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
//        galleryCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    func setupCusineCollectionView(uid: String) {
        cusineCollectionView.alignment = .center
        cusineCollectionView.scrollDirection = .horizontal
        cusineCollectionView.alignment = .fillByExpandingWidthExceptLastLine
        cusineCollectionView.delegate = self
        cusineCollectionView.enableTagSelection = false
        let config = TTGTextTagConfig()
        config.backgroundColor = UIColor.orangeColor()
        config.textColor = UIColor.white
        Firestore.firestore().collection(Constants.Chefs).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let array = document.data()?["cusine"] as? [String] else { return }
                let sortedArray = array.sorted(by: { $0 < $1 })
                for name in sortedArray {
                    self.cusineCollectionView.addTags([name], with: config)
                }
            } else {
                config.backgroundColor = .white
                config.textColor = UIColor.orangeColor()
                self.cusineCollectionView.addTag("Chef's working on it!'", with: config)
                print("Document does not exist")
            }
        }
    }
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username,
                  let city = user.city,
                  let state = user.state,
                  let bio = user.bio,
                  let uid = user.uid else { return }
            self.usernameLabel.text = username
            self.locationLabel.text = "\(city), \(state)"
            self.bioLabel.text = "About \(username)"
            self.bioTextLabel.text = bio
            if self.bioTextLabel.text == "" {
                self.bioTextLabel.text = "Full bio coming soon"
            }
            
            if user.isChef == false {
                
            }
            
            self.setupCusineCollectionView(uid: uid)
            self.fetchMenus(uid: uid)
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
    
    fileprivate func fetchMenus(uid: String) {
        MenuController.shared.fetchMenuWith(uid: uid) { (result) in
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
    
    @objc func viewReviews() {
        let reviewsVC = NewReviewVC()
        reviewsVC.userId = userId
        navigationController?.pushViewController(reviewsVC, animated: true)
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
        view.layer.opacity = 0.1
        return view
    }()
    
    let profileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = UIColor.orangeColor()?.cgColor
        image.image = UIImage(named: "person.crop.circle.fill")
        image.tintColor = UIColor.orangeColor()
        image.backgroundColor = .white
        image.layer.borderWidth = 2
        return image
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
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
    
    let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.backgroundColor = .gray
        return stackView
    }()

    let reviewCountLabel: UILabel = {
        let label = UILabel()
        label.text = "55 reviews"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let rebookCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "7 rebooks"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let verifiedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Verified Chef"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
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
    
    let cusineLabel: UILabel = {
        let label = UILabel()
        label.text = "What I'm know for:"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()
    
    let bioTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.textAlignment = .justified
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
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

    let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let galleryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
}

// MARK: - CollectionView
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.menuCollectionView {
            if MenuController.shared.menus.count == 0 {
                return CGSize(width: view.frame.width - 20, height: 200)
            } else {
                return CGSize(width: view.frame.width / 2, height: 200)
            }
        }
        return CGSize(width: 150, height: 200)
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
    //            let galleryDetail = GalleryDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
    //            galleryDetail.gallery = gallery
    //            navigationController?.pushViewController(galleryDetail, animated: true)
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
}
