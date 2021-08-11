//
//  RequestTableViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/10/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class RequestTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var booking: Booking? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Lifecycle Methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Helper Functions
    func configure() {
        guard let booking = booking else { return }
        if booking.chefUid == Auth.auth().currentUser?.uid ?? "" {
            guard let uid = booking.userUid else { return }
            UserController.shared.fetchUserWithUID(uid: uid) { (user) in
                guard let name = user.username else { return }
                self.nameLabel.text = "\(name) has requested a booking"
            }
            if booking.invoiceSent == true {
                invoiceLabel.text = "Invoice has been sent"
            } else {
                invoiceLabel.text = "Invoice has not been sent"
            }
            if booking.invoicePaid == true {
                paidLabel.text = "Paid"
            } else {
                paidLabel.text = "Paid: Pending"
            }
        } else {
            guard let uid = booking.chefUid else { return }
            UserController.shared.fetchUserWithUID(uid: uid) { (user) in
                guard let name = user.username else { return }
                self.nameLabel.text = "You sent a request to \(name)"
            }
        }
        if booking.isBooked == false {
            bookedLabel.text = "Booked: Pending"
        } else {
            bookedLabel.text = "Booked: Approved"
        }
        timestampLabel.text = booking.timestamp.timeAgoDisplay()
        dateLabel.text = booking.date
    }
    
    func setupViews() {
        addSubview(shadowView)
        addSubview(timestampLabel)
        addSubview(nameLabel)
        addSubview(dateIcon)
        addSubview(dateLabel)
        addSubview(bookedLabel)
        addSubview(invoiceLabel)
        addSubview(paidLabel)
    }
    
    func setupConstraints() {
        shadowView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        timestampLabel.anchor(top: shadowView.topAnchor, left: nil, bottom: nil, right: shadowView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5)
        nameLabel.anchor(top: timestampLabel.bottomAnchor, left: shadowView.leftAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        dateIcon.anchor(top: nameLabel.bottomAnchor, left: shadowView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 15, height: 15)
        dateLabel.anchor(top: dateIcon.topAnchor, left: dateIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 10)
        dateLabel.centerYAnchor.constraint(equalTo: dateIcon.centerYAnchor).isActive = true
        bookedLabel.anchor(top: dateLabel.bottomAnchor, left: shadowView.leftAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        invoiceLabel.anchor(top: bookedLabel.bottomAnchor, left: shadowView.leftAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        paidLabel.anchor(top: invoiceLabel.bottomAnchor, left: shadowView.leftAnchor, bottom: nil, right: shadowView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
    }
    
    //MARK: - Views
    let shadowView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
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
    
    var bookedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.orangeColor()
        return label
    }()
    
    var invoiceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.orangeColor()
        return label
    }()
    
    var paidLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.orangeColor()
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()
}
