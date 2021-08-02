//
//  EventDetailViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/29/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class EventDetailViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var userId: String?
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var event: Event? {
        didSet {
            fetchEvent()
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        fetchEvent()
        checkIfBookmarked()
    }
 
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor(),
              let title = event?.caption else { return }
        configureNavigationBar(withTitle: title, largeTitle: false, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(timestampLabel)
        scrollView.addSubview(eventImage)
        scrollView.addSubview(detailViews)
        scrollView.addSubview(captionLabel)
        scrollView.addSubview(bookmarkButton)
        scrollView.addSubview(locationIcon)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(dateIcon)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(timeIcon)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(rsvpButton)
        buttonStackView.addArrangedSubview(contactButton)
        guard let event = event else { return }
        if event.allowsContact == false && event.allowsRSVP == false {
            buttonStackView.isHidden = true
        } else if event.allowsContact == false {
            contactButton.isHidden = true
        } else if event.allowsRSVP == false {
            rsvpButton.isHidden = true
        }
    }
    
    func constrainViews() {
        let totalHeight = 270 + view.frame.width + captionLabel.frame.height + descriptionLabel.frame.height + 10
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        profileImage.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        usernameLabel.anchor(top: scrollView.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        timestampLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        eventImage.anchor(top: profileImage.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: view.frame.width)
        detailViews.anchor(top: eventImage.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: -30, paddingLeft: 5, paddingBottom: 10, paddingRight: 5)
        captionLabel.anchor(top: detailViews.topAnchor, left: detailViews.leftAnchor, bottom: nil, right: bookmarkButton.leftAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        bookmarkButton.anchor(top: nil, left: nil, bottom: nil, right: detailViews.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 20)
        bookmarkButton.centerYAnchor.constraint(equalTo: captionLabel.centerYAnchor).isActive = true
        locationIcon.anchor(top: captionLabel.bottomAnchor, left: detailViews.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15, height: 18)
        locationLabel.anchor(top: nil, left: locationIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        dateIcon.anchor(top: locationIcon.bottomAnchor, left: detailViews.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
        timeIcon.anchor(top: dateIcon.bottomAnchor, left: detailViews.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        timeLabel.anchor(top: timeIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        descriptionLabel.anchor(top: timeLabel.bottomAnchor, left: detailViews.leftAnchor, bottom: nil, right: detailViews.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        buttonStackView.anchor(top: descriptionLabel.bottomAnchor, left: detailViews.leftAnchor, bottom: nil, right: detailViews.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)

    }
    
    func fetchEvent() {
        guard let uid = event?.uid else { return }
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let event = self.event,
                  let start = event.startTime,
                  let end = event.endTime,
                  let eventImg = event.eventImageUrl,
                  let image = user.profileImageUrl,
                        let username = user.username else { return }
            self.profileImage.loadImage(urlString: image)
            self.usernameLabel.text = "Posted by: \(username)"
            let timestamp = event.timestamp.timeAgoDisplay()
            self.timestampLabel.text = timestamp
            self.eventImage.loadImage(urlString: eventImg)
            self.captionLabel.text = event.caption
            self.descriptionLabel.text = event.detail
            self.locationLabel.text = "453 12th street, Brooklyn NY"
            self.dateLabel.text = event.date
            self.timeLabel.text = "\(start) - \(end)"
        }
    }
    
    func checkIfBookmarked() {
        guard let id = event?.id,
              let uid = Auth.auth().currentUser?.uid else { return }
        BookmarkController.shared.checkIfBookmarkedEventWith(uid: uid, id: id) { result in
            switch result {
            case true:
                let image = UIImage(named: "bookmark_selected")?.withRenderingMode(.alwaysTemplate)
                self.bookmarkButton.setImage(image, for: .normal)
            case false:
                print("bookmark")
                let image = UIImage(named: "bookmark_unselected")?.withRenderingMode(.alwaysTemplate)
                self.bookmarkButton.setImage(image, for: .normal)
            }
        }
    }
    
    func anonymousUserAlert() {
        let accountAction = UIAlertController(title: "Hold on there" , message: "You must have an account to use this feature", preferredStyle: .actionSheet)
        let signupAction = UIAlertAction(title: "Create Account", style: .default) { _ in
            self.goToCreateAccount()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        accountAction.addAction(signupAction)
        accountAction.addAction(cancelAction)
        self.present(accountAction, animated: true)
    }
    
    func goToCreateAccount() {
        let createAccountVC = CreateAccountViewController()
        self.present(createAccountVC, animated: true)
    }
    
    //MARK: - Selectors
    @objc func handleBookmarked() {
        guard let uid = Auth.auth().currentUser?.uid,
              let id = event?.id else { return }
        UserController.shared.checkIfUserIsAnonymous(uid: uid) { result in
            switch result {
            case true:
                self.anonymousUserAlert()
            case false:
                BookmarkController.shared.bookmarkEventWith(uid: uid, eventId: id) { result in
                    switch result {
                    case true:
                        print("true")
                    case false:
                        print("false")
                    }
                }
                BookmarkController.shared.checkIfBookmarkedEventWith(uid: uid, id: id) { result in
                    switch result {
                    case true:
                        let image = UIImage(named: "bookmark_selected")?.withRenderingMode(.alwaysTemplate)
                        self.bookmarkButton.setImage(image, for: .normal)
                    case false:
                        let image = UIImage(named: "bookmark_unselected")?.withRenderingMode(.alwaysTemplate)
                        self.bookmarkButton.setImage(image, for: .normal)
                    }
                }
            }
        }
    }
    
    @objc func handleRSVP() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserController.shared.checkIfUserIsAnonymous(uid: uid) { result in
            switch result {
            case true:
                self.anonymousUserAlert()
            case false:
                print("need to setup now")
            }
        }
    }
    
    @objc func handleContact() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserController.shared.checkIfUserIsAnonymous(uid: uid) { result in
            switch result {
            case true:
                self.anonymousUserAlert()
            case false:
                let chatVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
                chatVC.userId = self.userId
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    //MARK: - Views
    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "gradientBackgroundHalf")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
    
    var eventImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "gradientBackgroundHalf")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        return image
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
    
    let detailViews: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.cornerRadius = 20
        return view
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 17)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var locationIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "location-pin-orange")
        return image
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    var dateIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "calendarOrange")
        return image
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    var timeIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "timeOrange")
        return image
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    var rsvpButton: UIButton = {
        let button = UIButton()
        button.setTitle("RSVP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleRSVP), for: .touchUpInside)
        return button
    }()
    
    var contactButton: UIButton = {
        let button = UIButton()
        button.setTitle("Contact", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleContact), for: .touchUpInside)
        return button
    }()
}
