//
//  PaymentDetailVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 6/13/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit

class PaymentDetailVC: UIViewController {
    
    var payment: Payment? {
        didSet {
            print(payment?.amount)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
}
