//
//  BookingRequestDetailViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/14/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class BookingRequestDetailViewController: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var userId: String?
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var booking: Booking? {
        didSet {
            fetchRequest()
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(scrollView)
        scrollView.addSubview(imageShadowView)
        scrollView.addSubview(profileImage)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(cuisineLabel)
        scrollView.addSubview(timestampLabel)
        scrollView.addSubview(locationIcon)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(dateIcon)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(timeIcon)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(numberOfCoursesLabel)
        scrollView.addSubview(numberOfPeopleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(additionalInfoButton)
        scrollView.addSubview(payButton)
        scrollView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(acceptButton)
        buttonStackView.addArrangedSubview(declineButton)
        scrollView.addSubview(statusLabel)
        
    }
    
    func constrainViews() {
        scrollView.isScrollEnabled = true
        let totalHeight = 270 + view.frame.width + descriptionLabel.frame.height
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        imageShadowView.anchor(top: scrollView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        imageShadowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.anchor(top: scrollView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.anchor(top: profileImage.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cuisineLabel.anchor(top: usernameLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        timestampLabel.anchor(top: cuisineLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        locationIcon.anchor(top: timestampLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 15, height: 18)
        locationLabel.anchor(top: nil, left: locationIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor).isActive = true
        dateIcon.anchor(top: locationIcon.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
        timeIcon.anchor(top: dateIcon.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        timeLabel.anchor(top: timeIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        timeLabel.centerYAnchor.constraint(equalTo: timeIcon.centerYAnchor).isActive = true
        numberOfCoursesLabel.anchor(top: timeLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        numberOfPeopleLabel.anchor(top: numberOfCoursesLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        descriptionLabel.anchor(top: numberOfPeopleLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
        
        guard let booking = booking,
              let userUid = booking.userUid,
              let chefUid = booking.chefUid else { return }
        if userUid == Auth.auth().currentUser?.uid ?? "" {
            additionalInfoButton.isHidden = true
            buttonStackView.isHidden = true
            if booking.invoiceSent == true {
                payButton.anchor(top: descriptionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, height: 45)
            } else {
                payButton.isHidden = true
            }

        } else {
            payButton.isHidden = true
            additionalInfoButton.anchor(top: descriptionLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
            buttonStackView.anchor(top: additionalInfoButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, height: 45)
        }
        
        if chefUid == Auth.auth().currentUser?.uid ?? "" {
            if booking.invoiceSent == true {
                buttonStackView.isHidden = true
                statusLabel.isHidden = false
                statusLabel.anchor(top: additionalInfoButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
            } else {
                buttonStackView.isHidden = false
                statusLabel.isHidden = true
            }
        }
    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Booking Request", largeTitle: false, backgroundColor: .white, titleColor: orange)
    }
    
    func fetchRequest() {
        guard let booking = booking,
              let userUid = booking.userUid,
              let chefUid = booking.chefUid else { return }
        if userUid == Auth.auth().currentUser?.uid ?? "" {
            UserController.shared.fetchUserWithUID(uid: chefUid) { (user) in
                self.userId = chefUid
                guard let start = booking.startTime,
                      let end = booking.endTime,
                      let image = user.profileImageUrl,
                      let username = user.username else { return }
                self.profileImage.loadImage(urlString: image)
                self.usernameLabel.text = username
                self.cuisineLabel.text = booking.cusineType
                let timestamp = booking.timestamp.timeAgoDisplay()
                self.timestampLabel.text = "Sent: \(timestamp)"
                self.locationLabel.text = booking.locationShort
                self.dateLabel.text = booking.date
                self.timeLabel.text = "\(start) - \(end)"
                self.numberOfCoursesLabel.text = "Number of courses: \(booking.numberOfCourses ?? 0)"
                self.numberOfPeopleLabel.text = "Number of guest: \(booking.numberOfPeople ?? 0)"
                guard let details = booking.detail else { return }
                let attributedText = NSMutableAttributedString(string: "Details:", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.gray])
                attributedText.append(NSAttributedString(string: " " + details, attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.gray]))
                self.descriptionLabel.attributedText = attributedText
                
            }
        } else {
            UserController.shared.fetchUserWithUID(uid: userUid) { (user) in
                self.userId = userUid
                guard let start = booking.startTime,
                      let end = booking.endTime,
                      let image = user.profileImageUrl,
                      let username = user.username else { return }
                self.profileImage.loadImage(urlString: image)
                self.usernameLabel.text = username
                self.cuisineLabel.text = booking.cusineType
                let timestamp = booking.timestamp.timeAgoDisplay()
                self.timestampLabel.text = "Sent: \(timestamp)"
                self.locationLabel.text = booking.locationShort
                self.dateLabel.text = booking.date
                self.timeLabel.text = "\(start) - \(end)"
                self.numberOfCoursesLabel.text = "Number of courses: \(booking.numberOfCourses ?? 0)"
                self.numberOfPeopleLabel.text = "Number of guest: \(booking.numberOfPeople ?? 0)"
                guard let details = booking.detail else { return }
                let attributedText = NSMutableAttributedString(string: "Details:", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.gray])
                attributedText.append(NSAttributedString(string: " " + details, attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.gray]))
                self.descriptionLabel.attributedText = attributedText
                self.additionalInfoButton.setTitle("Need more information from \(username)?", for: .normal)
            }
        }

    }
    
    func handleCreateStripeAccount() {
        let alertVC = UIAlertController(title: "Stripe Account Required", message: "You must connect with Stripe before you can create an invoice", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Create Stripe Account", style: .default) { action in
            let invoiceVC = StripeAccountViewController()
            self.navigationController?.pushViewController(invoiceVC, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    //MARK: - Selectors
    @objc func handleSendMessage() {
        let chatVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.userId = userId
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    @objc func handleAccept() {
        guard let chefUid = booking?.chefUid else { return }
        let docRef = Firestore.firestore().collection(Constants.StripeAccounts).document(chefUid)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let invoiceVC = CreateInvoiceViewController()
                invoiceVC.booking = self.booking
                self.navigationController?.pushViewController(invoiceVC, animated: true)
            } else {
                self.handleCreateStripeAccount()
            }
        }
//        let invoiceVC = CreateInvoiceViewController()
//        invoiceVC.booking = booking
//        navigationController?.pushViewController(invoiceVC, animated: true)
    }
    
    @objc func handleDecline() {
        guard let booking = booking,
              let id = booking.id,
              let chefUid = booking.chefUid,
              let userUid = booking.userUid else { return }
        BookingController.shared.updateBookingPaymentRequestWith(paymentId: "", bookingId: id, chefUid: chefUid, userUid: userUid, isBooked: false, invoiceSent: false, invoicePaid: false, archive: true) { (result) in
            switch result {
            default:
                print("complete")
            }
        }
    }
    
    //MARK: - Views
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 25
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()
    
    var profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        return image
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = UIColor.orangeColor()
        return label
    }()
    
    var cuisineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.orangeColor()
        return label
    }()
    
    var timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.orangeColor()
        return label
    }()
    
    let numberOfPeopleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let numberOfCoursesLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    var additionalInfoButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font =  UIFont(name: "", size: 13)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    var acceptButton: UIButton = {
        let button = UIButton()
        //add checkmark
        button.setTitle("Accept Request", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleAccept), for: .touchUpInside)
        return button
    }()
    
    var declineButton: UIButton = {
        let button = UIButton()
        // add decline X
        button.setTitle("Decline Request", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleDecline), for: .touchUpInside)
        return button
    }()
    
    var payButton: UIButton = {
        let button = UIButton()
        // add decline X
        button.setTitle("Pay", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleDecline), for: .touchUpInside)
        return button
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Invoice has been sent and awaiting approval."
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

}
