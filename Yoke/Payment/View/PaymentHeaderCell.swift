//
//  PaymentHeaderCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 6/17/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit

protocol PaymentProfileHeaderDelegate {
    func viewHandleStripe()
    func viewCreateInvoice()
}

class PaymentHeaderCell: UICollectionViewCell {
    
    var delegate: PaymentProfileHeaderDelegate?
    
    lazy var stripeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Balance & Withdraw", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainColor().cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(handleStripe), for: .touchUpInside)
        return button
    }()

    @objc func handleStripe() {
        print("withdrawl")
        delegate?.viewHandleStripe()
    }
    
    lazy var invoiceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Payment Request", for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.mainColor().cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(handleInvoice), for: .touchUpInside)
        return button
    }()

    @objc func handleInvoice() {
        print("withdrawl")
        delegate?.viewCreateInvoice()
    }

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.stripeButton.titleLabel?.numberOfLines = 0
        self.stripeButton.titleLabel?.textAlignment = .center
        self.invoiceButton.titleLabel?.textAlignment = .center

        let buttonView = UIStackView(arrangedSubviews: [stripeButton, invoiceButton])
        buttonView.axis = .horizontal
        buttonView.distribution = .fillEqually
        buttonView.spacing = 5
        addSubview(buttonView)
        buttonView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 75)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
