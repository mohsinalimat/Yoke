//
//  Payment.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Payment {
    var paymentId: String
    var total: Double
    var reference: String
    var text: String
    var timestamp: Date
    
    init(dictionary: [String: Any]) {
        self.paymentId = dictionary[Constants.PaymentId] as? String ?? ""
        self.total = dictionary[Constants.Total] as? Double ?? 0.0
        self.reference = dictionary[Constants.Reference] as? String ?? ""
        self.text = dictionary[Constants.Text] as? String ?? ""
        let secondsFrom1970 = dictionary[Constants.Timestamp] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

extension Payment: Equatable {
    static func == (lhs: Payment, rhs: Payment) -> Bool {
        return lhs.paymentId == rhs.paymentId
    }
}
