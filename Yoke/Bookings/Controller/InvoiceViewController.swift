//
//  InvoiceViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 10/27/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class invoiceViewController: UIViewController {
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var currentUserUid = Auth.auth().currentUser?.uid ?? ""
    var userId: String?
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var booking: Booking? {
        didSet {
            fetchBookingRequest()
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
        view.addSubview(myActivityIndicator)
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
        scrollView.addSubview(amountLabel)
        scrollView.addSubview(amountTextField)
        scrollView.addSubview(detailsViewBG)
        scrollView.addSubview(detailsTextField)
        scrollView.addSubview(submitButton)
    }
    
    func constrainViews() {
        scrollView.isScrollEnabled = true
        let totalHeight = 270 + view.frame.width + descriptionLabel.frame.height
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        usernameLabel.anchor(top: scrollView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
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
        amountLabel.anchor(top: numberOfPeopleLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 45)
        amountTextField.anchor(top: nil, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 100, height: 45)
        amountTextField.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor).isActive = true
        detailsViewBG.anchor(top: amountTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, height: 100)
        detailsTextField.anchor(top: amountTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, height: 200)
        submitButton.anchor(top: detailsTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 50)
        
        myActivityIndicator.center = view.center
    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Invoice", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func sentSuccessful() {
        let alertVC = UIAlertController(title: "Success", message: "Your request has been sent!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool Beans", style: .default) { (_) in
            self.handleDismiss()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func sentFailed() {
        let alertVC = UIAlertController(title: "Failed", message: "Something went wrong, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func fetchBookingRequest() {
        guard let booking = booking,
              let userUid = booking.userUid else { return }
        UserController.shared.fetchUserWithUID(uid: userUid) { (user) in
            self.userId = userUid
            guard let start = booking.startTime,
                  let end = booking.endTime,
                  let username = user.username else { return }
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
    }
    
    //MARK: - Selectors
    
    @objc func handleSubmit() {
        guard let booking = booking,
              let id = booking.id,
              let chefUid = booking.chefUid,
              let userUid = booking.userUid,
              let total = amountLabel.text else { return }
        let notes = detailsTextField.text ?? ""
        self.myActivityIndicator.startAnimating()
        BookingController.shared.updateBookingPaymentRequestWith(bookingId: id, chefUid: chefUid, userUid: userUid, isBooked: true, invoiceSent: true, notes: notes, total: total) { (result) in
            switch result {
            default:
                self.myActivityIndicator.stopAnimating()
                self.sentSuccessful()
            }
        }
    }
    
    
    @objc func handleDismiss() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        view.layer.borderWidth = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Job Details"
        return label
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
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Amount:"
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let amountTextField: UITextField = {
        let text = UITextField()
        text.textColor = .darkGray
        text.attributedPlaceholder = NSAttributedString(string: "$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        text.keyboardType = .decimalPad
        text.layer.cornerRadius = 10
        text.layer.shadowOffset = CGSize(width: 0, height: 4)
        text.layer.shadowRadius = 4
        text.layer.shadowOpacity = 0.1
        text.layer.shadowColor = UIColor.gray.cgColor
        text.backgroundColor = UIColor.white
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        return text
    }()
    
    let detailsViewBG: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let detailsTextField: UITextView = {
        let text = UITextView()
        text.placeholder = "Enter notes..."
        text.backgroundColor = .white
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        return text
    }()
    
    
    let detailTextField: UITextView = {
        let text = UITextView()
        text.placeholder = "Enter any additional information ..."
        text.backgroundColor = .white
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        return text
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
}
