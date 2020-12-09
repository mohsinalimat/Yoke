//
//  Payment.swift
//  FooD
//
//  Created by LAURA JELENICH on 4/24/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class Payment {
    var key: String!
    let user: User
    let uid: String
    let fromUser: String
    let toUser: String
//    let amount: Double
    let amount: Int
    let currency: Int
    let description: String
    let reference: String
    let eventDate: String?
    let timestamp: Timestamp
    let creationDate: Date?
    let status: String
    
    init(user: User, dictionary: [String: Any], snapshot: DataSnapshot) {
        self.key = snapshot.key
        self.user = user
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        self.fromUser = dictionary[Constants.FromUser] as? String ?? ""
        self.toUser = dictionary[Constants.ToUser] as? String ?? ""
//        self.amount = dictionary[Constants.Amount] as? Double ?? 0.0
        self.amount = dictionary[Constants.Amount] as? Int ?? 0
        self.currency = dictionary["currency"] as? Int ?? 0
        self.description = dictionary[Constants.Description] as? String ?? ""
        self.reference = dictionary[Constants.PaymentReference] as? String ?? ""
        self.eventDate = dictionary[Constants.EventDate] as? String ?? ""
        let secondsFrom1970CD = dictionary[Constants.CreationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970CD)
        self.timestamp = dictionary[Constants.Timestamp] as? Timestamp ?? Timestamp()
        self.status = dictionary[Constants.Status] as? String ?? ""
    }
    
}
