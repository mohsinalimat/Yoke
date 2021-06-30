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
import MessageUI

class ProfileViewController: UIViewController, TTGTextTagCollectionViewDelegate, MFMailComposeViewControllerDelegate {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var userId: String?
    let cusineCollectionView = TTGTextTagCollectionView()
    let noCellId = "noCellId"
    let cellId = "cellId"
    var user: User?
    var reportUsername: String = ""
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupCollectionView()
        checkIfBookmarked()
    }

    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "", largeTitle: false, backgroundColor: UIColor.white, titleColor: orange)
        let filterIcon = UIImage(named: "dottedMenu")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.image = filterIcon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(handleBlockReport))
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(bannerImageView)
        scrollView.addSubview(bannerLayerImage)
        scrollView.addSubview(usernameView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(ratingView)
        self.setupForChef()
        self.constrainViewsForChef()
//        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
//        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
//            if user.isChef == false {
//                self.setupForUser()
//                self.constrainViewsForUser()
//            } else {
//                self.setupForChef()
//                self.constrainViewsForChef()
//            }
//        }
    }
    
    func setupForUser() {
        scrollView.addSubview(reviewsButton)
        scrollView.addSubview(bioView)
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(bioTextLabel)
    }
    
    func setupForChef() {
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(reviewsButton)
        buttonStackView.addArrangedSubview(eventButton)
        buttonStackView.addArrangedSubview(messageButton)
        buttonStackView.addArrangedSubview(bookmarkButton)
        scrollView.addSubview(bioView)
        scrollView.addSubview(bioLabel)
        scrollView.addSubview(bioTextLabel)
        scrollView.addSubview(cusineView)
        scrollView.addSubview(cusineLabel)
        scrollView.addSubview(cusineCollectionView)
        scrollView.addSubview(collectionViewBG)
        scrollView.addSubview(menuLabel)
        scrollView.addSubview(menuCollectionView)
    }
    
//    func constrainViews() {
//        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
//        bannerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)
//
//        bannerLayerImage.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)
//
//        profileImageView.anchor(top: bannerImageView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 150, height: 150)
//        profileImageView.layer.cornerRadius = 75
//
//        usernameView.anchor(top: usernameLabel.topAnchor, left: safeArea.leftAnchor, bottom: bannerImageView.bottomAnchor, right: usernameLabel.rightAnchor, paddingTop: -10, paddingLeft: 50, paddingBottom: 0, paddingRight: -10)
//        usernameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
//        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
//        locationLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
//        ratingView.anchor(top: locationLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 25)
//
//        setupButtonImages()
//        buttonStackView.anchor(top: profileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 70)
//        buttonStackView.backgroundColor = .green
//
//        bioView.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: bioTextLabel.bottomAnchor, right: safeArea.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
//
//        bioLabel.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingBottom: 0, paddingRight: 5)
//
//        bioTextLabel.anchor(top: bioLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
//
//        cusineView.anchor(top: bioView.bottomAnchor, left: safeArea.leftAnchor, bottom: cusineCollectionView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
//        cusineLabel.anchor(top: bioView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0)
//        cusineCollectionView.anchor(top: cusineLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 5, height: 45)
//        collectionViewBG.anchor(top: cusineCollectionView.bottomAnchor, left: safeArea.leftAnchor, bottom: scrollView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, height: 200)
//
//        menuLabel.anchor(top: collectionViewBG.topAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 5)
//
//        menuCollectionView.anchor(top: menuLabel.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: collectionViewBG.bottomAnchor, right: collectionViewBG.rightAnchor, paddingTop: -30, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
//    }
    
    func setupButtonImages() {
        reviewsButton.alignImageTextVertical()
        eventButton.alignImageTextVertical()
        bookmarkButton.alignImageTextVertical()
        messageButton.alignImageTextVertical()
    }
    
    func constrainViewsForChef() {
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        bannerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)
    
        bannerLayerImage.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)
        
        profileImageView.anchor(top: bannerImageView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 150, height: 150)
        profileImageView.layer.cornerRadius = 75
        
        usernameView.anchor(top: usernameLabel.topAnchor, left: safeArea.leftAnchor, bottom: bannerImageView.bottomAnchor, right: usernameLabel.rightAnchor, paddingTop: -10, paddingLeft: 50, paddingBottom: 0, paddingRight: -10)
        usernameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        locationLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        ratingView.anchor(top: locationLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 25)
        
        setupButtonImages()
        buttonStackView.anchor(top: profileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 70)
        buttonStackView.backgroundColor = .green
        
        bioView.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: bioTextLabel.bottomAnchor, right: safeArea.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)

        bioLabel.anchor(top: buttonStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 25, paddingLeft: 15, paddingBottom: 0, paddingRight: 5)

        bioTextLabel.anchor(top: bioLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
        
        cusineView.anchor(top: bioView.bottomAnchor, left: safeArea.leftAnchor, bottom: cusineCollectionView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        cusineLabel.anchor(top: bioView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0)
        cusineCollectionView.anchor(top: cusineLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 5, height: 45)
        collectionViewBG.anchor(top: cusineCollectionView.bottomAnchor, left: safeArea.leftAnchor, bottom: scrollView.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, height: 200)

        menuLabel.anchor(top: collectionViewBG.topAnchor, left: collectionViewBG.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 5)

        menuCollectionView.anchor(top: menuLabel.bottomAnchor, left: collectionViewBG.leftAnchor, bottom: collectionViewBG.bottomAnchor, right: collectionViewBG.rightAnchor, paddingTop: -30, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
    }
    
    func constrainViewsForUser() {
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        bannerImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)
    
        bannerLayerImage.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 300)
        
        profileImageView.anchor(top: bannerImageView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 150, height: 150)
        profileImageView.layer.cornerRadius = 75
        
        usernameView.anchor(top: usernameLabel.topAnchor, left: safeArea.leftAnchor, bottom: bannerImageView.bottomAnchor, right: usernameLabel.rightAnchor, paddingTop: -10, paddingLeft: 50, paddingBottom: 0, paddingRight: -10)
        usernameLabel.anchor(top: nil, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        locationLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        ratingView.anchor(top: locationLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 120, height: 25)
        reviewsButton.alignImageTextVertical()
        reviewsButton.anchor(top: locationLabel.topAnchor, left: ratingView.rightAnchor, bottom: ratingView.bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        bioView.anchor(top: bioLabel.topAnchor, left: safeArea.leftAnchor, bottom: bioTextLabel.bottomAnchor, right: safeArea.rightAnchor, paddingTop: -10, paddingLeft: 5, paddingBottom: -10, paddingRight: 5)

        bioLabel.anchor(top: profileImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 5)

        bioTextLabel.anchor(top: bioLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15)
    }
    
    func setupCollectionView() {
        menuCollectionView.backgroundColor = .clear
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuCollectionView.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        menuCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
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
        config.borderColor = .clear
        config.shadowRadius = 4
        config.shadowOpacity = 0.5
        config.shadowColor = UIColor.gray
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
    
    //MARK: - API
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username,
                  let city = user.city,
                  let state = user.state,
                  let bio = user.bio,
                  let uid = user.uid else { return }
            self.usernameLabel.text = username
            self.reportUsername = username
            self.locationLabel.text = "\(city), \(state)"
            self.bioLabel.text = "About \(username)"
            self.bioTextLabel.text = bio
            if self.bioTextLabel.text == "" {
                self.bioTextLabel.text = "Full bio coming soon"
            }
            if user.isChef == true {
                self.rebookCountLabel.text = "7 rebooks"
                self.verifiedLabel.text = "Verified Chef"
            } else {
                self.rebookCountLabel.text = ""
                self.verifiedLabel.text = ""
            }
            self.fetchUserAverageRating(uid: uid)
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
//                    self.bannerImageView.image = UIImage(data: data)
                }
            }
        }
    }
    
    func fetchUserAverageRating(uid: String) {
        Firestore.firestore().collection(Constants.Users).document(uid).collection(Constants.Ratings).getDocuments() { (querySnapshot, error) in
            var totalCount = 0.0
            var count = 0.0
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                count = Double(querySnapshot?.count ?? 0)
                for document in querySnapshot!.documents {
                    if let rate = document.data()[Constants.Stars] as? Double {
                        if count == 1 {
                            self.reviewsButton.setTitle("\(Int(count)) Review", for: .normal)
                        } else if count > 1 {
                            self.reviewsButton.setTitle("\(Int(count)) Reviews", for: .normal)
                        }
                        totalCount += rate
                        print("stars total count \(totalCount), rate \(rate)")
                    }
                }
            }
            let average = totalCount/count
            print("stars \(uid), \(average)")
            self.ratingView.rating = average
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
    
    func checkIfBookmarked() {
        let bookmarkedUser = self.userId ?? (Auth.auth().currentUser?.uid ?? "")
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
    
    //MARK: - Blocking functions
    func unblock() {
        let menu = UIAlertController(title: "Choose Option" , message: "", preferredStyle: .actionSheet)
        let unBlockAction = UIAlertAction(title: "Unblock", style: .default) { _ in
            self.blockUnblock()
        }
        let reportAction = UIAlertAction(title: "Report User", style: .default) { _ in
            self.reportUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        menu.addAction(unBlockAction)
        menu.addAction(reportAction)
        menu.addAction(cancelAction)
        self.present(menu, animated: true)
    }
    
    func block() {
        let menu = UIAlertController(title: "Choose Option" , message: "", preferredStyle: .actionSheet)
        
        let blockAction = UIAlertAction(title: "Block", style: .default) { _ in
            self.blockUnblock()
        }
        let reportAction = UIAlertAction(title: "Report User", style: .default) { _ in
            print("report")
            self.reportUser()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        menu.addAction(blockAction)
        menu.addAction(reportAction)
        menu.addAction(cancelAction)
        self.present(menu, animated: true)
    }
    
    func blockUnblock() {
        let userToBlockUid = self.userId ?? (Auth.auth().currentUser?.uid ?? "")
        guard let userBlockingUid = Auth.auth().currentUser?.uid else { return }
        ReportBlockController.shared.blockUserWith(userBlockingUid: userBlockingUid, userToBlockUid: userToBlockUid) { result in
            switch result {
            case true:
                print("true")
            case false:
                print("false")
            }
        }
    }
    
    func reportUser() {
        let uidReporting = self.userId ?? (Auth.auth().currentUser?.uid ?? "")
        guard let uidBeingReported = Auth.auth().currentUser?.uid else { return }
        let reportSheet = UIAlertController(title: "Report" , message: "Please let us know why you are reporting this user.", preferredStyle: .actionSheet)
        let inappropriateAction = UIAlertAction(title: "User is being inappropriate", style: .default) { _ in
            ReportBlockController.shared.sendReport(sendingReportUserUid: uidReporting, userBeingReportedUid: uidBeingReported, text: "User is being inappropriate") { result in
                switch result {
                case true:
                    print("sent")
                case false:
                    print("error sending report")
                }
            }
        }
        let notUserAction = UIAlertAction(title: "User isn't who they say they are", style: .default) { _ in
            ReportBlockController.shared.sendReport(sendingReportUserUid: uidReporting, userBeingReportedUid: uidBeingReported, text: "User isn't who they say they are") { result in
                switch result {
                case true:
                    print("sent")
                case false:
                    print("error sending report")
                }
            }
        }
        
        let otherAction = UIAlertAction(title: "Other", style: .default) { _ in
            self.reportCustomReason()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        reportSheet.addAction(inappropriateAction)
        reportSheet.addAction(notUserAction)
        reportSheet.addAction(otherAction)
        reportSheet.addAction(cancelAction)
        self.present(reportSheet, animated: true)
    }
    
    func reportCustomReason() {
        let alertController = UIAlertController(title: "Report User", message: "Please let us know the reason for reporting \(reportUsername)", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter reason here"
        })
        let action = UIAlertAction(title: "Submit", style: .default, handler: {[weak self] (paramAction:UIAlertAction!) in
            if let textFields = alertController.textFields{
                let theTextFields = textFields as [UITextField]
                let enteredText = theTextFields[0].text
                guard let text = enteredText else { return }
                let uidReporting = self?.userId ?? (Auth.auth().currentUser?.uid ?? "")
                guard let uidBeingReported = Auth.auth().currentUser?.uid else { return }
                ReportBlockController.shared.sendReport(sendingReportUserUid: uidReporting, userBeingReportedUid: uidBeingReported, text: text) { result in
                    switch result {
                    case true:
                        print("sent")
                    case false:
                        print("error sending report")
                    }
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    //MARK: - Selectors
    @objc func viewReviews() {
        let reviewsVC = ReviewsCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        reviewsVC.userId = userId
        navigationController?.pushViewController(reviewsVC, animated: true)
    }
    
    @objc func handleSendRequest() {
        let requestVC = BookingRequestViewController()
        requestVC.userId = userId
        navigationController?.pushViewController(requestVC, animated: true)
//        let chatVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        print("pressed")
//        chatVC.userId = userId
//        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func handleBlockReport() {
        let userToBlockUid = self.userId ?? (Auth.auth().currentUser?.uid ?? "")
        guard let userBlockingUid = Auth.auth().currentUser?.uid else { return }
        ReportBlockController.shared.checkIfBlocked(userBlockingUid: userBlockingUid, userToBlockUid: userToBlockUid) { result in
            switch result {
            case true:
                self.unblock()
            case false:
                self.block()
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
//        image.image = UIImage(named: "gradientBackgroundHalf")
        return image
    }()
    
    let bannerLayerImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "gradientBlack")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
//        image.alpha = 0.8
        return image
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
        image.layer.shadowColor = UIColor.lightGray.cgColor
        return image
    }()
    
    let usernameView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = UIColor.white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        return label
    }()
    
    let ratingView: RatingView = {
        let view = RatingView()
        view.backgroundColor = .clear
        view.minRating = 0
        view.maxRating = 5
        view.rating = 2.5
        view.editable = false
        view.emptyImage = UIImage(systemName: "star")
        view.fullImage = UIImage(systemName: "star.fill")
        view.tintColor = UIColor.orangeColor()
        return view
    }()
    
    let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.backgroundColor = UIColor.clear
        stackView.layer.cornerRadius = 10
//        stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        stackView.layer.shadowRadius = 4
//        stackView.layer.shadowOpacity = 0.1
//        stackView.layer.shadowColor = UIColor.gray.cgColor
        return stackView
    }()
    
    let rebookCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    let verifiedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
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
//        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
//        button.layer.borderColor = UIColor.orangeColor()?.cgColor
//        button.layer.borderWidth = 0.5
        return button
    }()
    
    lazy var eventButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "event_full"), for: .normal)
        let image = UIImage(named: "event_full")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.orangeColor()
        button.setTitle("Events", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
//        button.addTarget(self, action: #selector(handleEvents), for: .touchUpInside)
//        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
//        button.layer.borderColor = UIColor.orangeColor()?.cgColor
//        button.layer.borderWidth = 0.5
        return button
    }()
    
    lazy var messageButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "calendar"), for: .normal)
        let image = UIImage(named: "message_selected")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.orangeColor()
        button.setTitle("Request Chef", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleSendRequest), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
//        let image = UIImage(named: "bookmark_selected")?.withRenderingMode(.alwaysTemplate)
//        button.setImage(image, for: .normal)
        button.tintColor = UIColor.orangeColor()
//        button.setTitle("Bookmarked", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleBookmarked), for: .touchUpInside)
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = UIColor.LightGrayBg()
        stackView.layer.cornerRadius = 20
//        stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        stackView.layer.shadowRadius = 4
//        stackView.layer.shadowOpacity = 0.1
//        stackView.layer.shadowColor = UIColor.lightGray.cgColor
        return stackView
    }()
    
    let bioView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.LightGrayBg()
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowRadius = 4
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.gray
        label.textAlignment = .left
        label.backgroundColor = UIColor.LightGrayBg()
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
        label.backgroundColor = UIColor.LightGrayBg()
        return label
    }()
    
    let cusineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.LightGrayBg()
//        view.layer.cornerRadius = 10
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowRadius = 4
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let cusineLabel: UILabel = {
        let label = UILabel()
        label.text = "What I'm know for:"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.gray
        label.textAlignment = .center
        return label
    }()
    
    let collectionViewBG: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.LightGrayBg()
//        view.layer.cornerRadius = 10
//        view.layer.shadowOffset = CGSize(width: 0, height: 4)
//        view.layer.shadowRadius = 4
//        view.layer.shadowOpacity = 0.1
//        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let menuViewBG: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.text = "Menus"
        label.textColor = .gray
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
                noCell.noPostLabel.text = "Coming soon!"
                noCell.noPostLabel.font = UIFont.systemFont(ofSize: 15)
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
                return CGSize(width: view.frame.width - 40, height: 160)
//                return CGSize(width: view.frame.width / 2, height: 200)
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
                let menuVC = MenuViewController()
                menuVC.menu = menu
                present(menuVC, animated: true)
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

