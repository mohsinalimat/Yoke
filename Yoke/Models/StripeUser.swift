//
//  StripeUser.swift
//  FooD
//
//  Created by LAURA JELENICH on 6/5/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class StripeUser {
    
    let id: String
    let customer_id: String
    let email: String
    
    
    init(id: String = "", customer_id: String = "", email: String = "") {
        self.id = id
        self.customer_id = customer_id
        self.email = email
    }
    
    init(data: [String: Any]) {
        self.id = data[Constants.Id] as? String ?? ""
        self.customer_id = data[Constants.CustomerId] as? String ?? ""
        self.email = data[Constants.Email] as? String ?? ""
    }
    
    static func modelToData(customer_id: StripeUser) -> [String: Any] {
        let data : [String: Any] = [Constants.Id: customer_id.id, Constants.Email: customer_id.email, Constants.CustomerId: customer_id.customer_id]
        return data
    }
}
