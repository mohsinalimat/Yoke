//
//  MakePaymentViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class MakePaymentViewController: UIViewController {
    
    //MARK: Properties
    var booking: Booking? {
        didSet {
            fetchInvoice()
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Payment", largeTitle: false, backgroundColor: .white, titleColor: orange)
    }
    
    func fetchInvoice() {
        guard let booking = booking,
              let paymentId = booking.paymentId,
              let uid = booking.userUid else { return }
        print(booking, paymentId, uid)
        
    }

}
