//
//  _StripeCheckout.swift
//  FooD
//
//  Created by LAURA JELENICH on 3/16/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import Foundation

let StripeCheckout = _StripeCheckout()

final class _StripeCheckout {
    
    private let stripeCreditCardCut = 0.029
    private let flatFeeCents = 30
    
    var subtotal: Int {
        var amount = 0
        let pricePennies = Int(amount * 100)
        amount += pricePennies
        return amount
    }
    
    var processingFees : Int {
        if subtotal == 0 {
            return 0
        }
        
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeCreditCardCut) + flatFeeCents
        return feesAndSub
    }
    
    var total : Int {
        return subtotal + processingFees
    }
    
}
