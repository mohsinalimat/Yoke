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

    }
    
    func fetchInvoice() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
