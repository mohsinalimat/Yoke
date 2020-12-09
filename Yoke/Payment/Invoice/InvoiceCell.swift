//
//  InvoiceCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 5/7/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class InvoiceCell: UICollectionViewCell {
    
    private let stripeFee = 0.29
    private let flatFeeCents = 30.00
    private let fee = 20.00
    var totalAmount: Double = 0.0
    
    var user: User?
    var payment: Payment? {
        didSet {
            guard let payment = payment else { return }
            fromLabel.text = "Created by: \(payment.user.username)"
            referenceLabel.text = "reference: \(payment.reference)"
            eventDateLabel.text = payment.eventDate
            statusLabel.text = payment.status
            
            let amount = payment.amount
            totalAmount = Double(amount)
            
            getToUserUsername()
            getTotal()
        }
    }
    
    var processingFees : Int {
        if totalAmount == 0 {
            return 0
        }
        let sub = Double(totalAmount)
        //        let feesAndSub = Int(sub * stripeFee + fee) + flatFeeCents
        //        let procFees = Int(sub * stripeFee + fee + flatFeeCents)
        let feesAndSub = Int(sub * stripeFee + fee + flatFeeCents)
        return feesAndSub
    }
    
    var total : Int {
        return Int(totalAmount * 100) - processingFees
    }
    
    func getTotal() {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if uid == payment?.fromUser {
            amountLabel.text = "\(total.penniesToFormattedCurrency())"
        } else {
            guard let amount = payment?.amount else {return}
            amountLabel.text = "$\(amount)"
            var total : Int {
                return Int(amount * 100)
            }
        }
        
        
        
//        let convertTotal = total.penniesToFormattedCurrency()
//
//        amountLabel.text = convertTotal
    }
    
    func getToUserUsername() {
        Database.database().reference().child(Constants.Payments).child(payment!.key).observe(.value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let uid = dictionary[Constants.ToUser] as? String else {return}
            Database.database().reference().child(Constants.Users).child(uid).observe(.value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                guard let username = dictionary[Constants.Username] as? String else {return}
                self.toLabel.text = "Sent to: \(username)"
            })
        }
    }
    
    let fromLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let toLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let referenceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let eventDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let creationDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(fromLabel)
        addSubview(toLabel)
        addSubview(referenceLabel)
        addSubview(amountLabel)
        addSubview(descriptionLabel)
        addSubview(statusLabel)
        
        fromLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        toLabel.anchor(top: fromLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        referenceLabel.anchor(top: toLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        descriptionLabel.anchor(top: referenceLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        statusLabel.anchor(top: referenceLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        amountLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
