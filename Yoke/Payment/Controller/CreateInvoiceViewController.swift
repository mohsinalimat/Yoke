//
//  CreateInvoiceViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/14/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class CreateInvoiceViewController: UIViewController {
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
        fetchRequest()
        
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(backgroundView)
        backgroundView.addSubview(toLabel)
        backgroundView.addSubview(dateLabel)
        backgroundView.addSubview(amountLabel)
        backgroundView.addSubview(amountTextField)
        backgroundView.addSubview(serviceFeeLabel)
        backgroundView.addSubview(totalLabel)
        backgroundView.addSubview(referenceShadow)
        backgroundView.addSubview(referenceTextField)
        backgroundView.addSubview(messageShadow)
        backgroundView.addSubview(messageTextField)
        backgroundView.addSubview(sendButton)
    }
    
    func constrainViews() {
        backgroundView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: sendButton.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: -20, paddingRight: 10)
        toLabel.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        dateLabel.anchor(top: toLabel.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        amountLabel.anchor(top: dateLabel.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, height: 45)
        amountTextField.anchor(top: nil, left: nil, bottom: nil, right: backgroundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 100, height: 45)
        amountTextField.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor).isActive = true
        
        serviceFeeLabel.anchor(top: amountLabel.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        totalLabel.anchor(top: serviceFeeLabel.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        referenceShadow.anchor(top: totalLabel.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: backgroundView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
        referenceTextField.anchor(top: totalLabel.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: backgroundView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
        messageShadow.anchor(top: referenceShadow.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: backgroundView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 150)
        messageTextField.anchor(top: referenceShadow.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: backgroundView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 150)
        sendButton.anchor(top: messageTextField.bottomAnchor, left: backgroundView.leftAnchor, bottom: nil, right: backgroundView.rightAnchor, paddingTop: 20, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, height: 45)
    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Create Invoice", largeTitle: false, backgroundColor: .white, titleColor: orange)
    }
    
    //MARK: - API
    func fetchRequest() {
        guard let booking = booking,
              let uid = booking.userUid else { return }
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username,
                  let date = booking.date else { return }
            self.toLabel.text = "Send to: \(username)"
            self.dateLabel.text = "Date of event: \(date)"
        }
    }
    
    //MARK: - Selectors
    @objc func handleSend() {
        guard let booking = booking,
              let bookingId = booking.id,
              let uid = booking.userUid,
              let chefUid = booking.chefUid else { return }
        PaymentController.shared.createPaymentWith(bookingId: bookingId, chefUid: chefUid, userUid: uid, amount: 0.0, fees: 0.0, total: 0.0, reference: "", description: "", paid: false) { (result) in
            switch result {
            case true:
                print("success")
            case false:
                print("fail")
            }
        }
        
        BookingController.shared.updateBookingPaymentRequestWith(bookingId: bookingId, chefUid: chefUid, userUid: uid, isBooked: false, invoiceSent: true, invoicePaid: false, archive: false) { (result) in
            switch result {
            case true:
                print("success")
            case false:
                print("fail")
            }
        }
    }
    
    //MARK: - Views
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.gray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let toLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
    
    let serviceFeeLabel: UILabel = {
        let label = UILabel()
        label.text = "Fees"
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total: "
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    let referenceShadow: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let referenceTextField: UITextView = {
        let text = UITextView()
        text.placeholder = "Enter reference here..."
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        text.layer.cornerRadius = 10
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        return text
    }()
    
    let messageShadow: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let messageTextField: UITextView = {
        let text = UITextView()
        text.placeholder = "Enter additional information ..."
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        text.layer.cornerRadius = 10
        text.layer.borderWidth = 0.5
        text.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        return text
    }()
    
    var sendButton: UIButton = {
        let button = UIButton()
        // add decline X
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()

}
