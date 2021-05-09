//
//  MakePaymentViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class MakePaymentViewController: UIViewController {

    var booking: Booking? {
        didSet {
            fetchInvoice()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Payment", largeTitle: false, backgroundColor: .white, titleColor: orange)
    }
    
    func fetchInvoice() {
        guard let booking = booking,
              let paymentId = booking.payment?.paymentId,
              let uid = booking.userUid else { return }
        print("payment \(booking.id), \(uid)")
    }

}
