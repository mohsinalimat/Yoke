//
//  Payment.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Payment {
    var booking: Booking?
    var paymentId: String
    var total: Double
    var reference: String
    
    init(dictionary: [String: Any]) {
        self.paymentId = dictionary[Constants.PaymentId] as? String ?? ""
        self.total = dictionary[Constants.Total] as? Double ?? 0.0
        self.reference = dictionary[Constants.Reference] as? String ?? ""
    }
}

extension Payment: Equatable {
    static func == (lhs: Payment, rhs: Payment) -> Bool {
        return lhs.paymentId == rhs.paymentId
    }
}
