//
//  Stripe.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/20/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Stripe {

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
        self.customer_id = data["customer_id"] as? String ?? ""
        self.email = data[Constants.Email] as? String ?? ""
    }
    
    static func modelToData(customer_id: StripeUser) -> [String: Any] {
        let data : [String: Any] = [Constants.Id: customer_id.id, Constants.Email: customer_id.email, "customer_id": customer_id.customer_id]
        return data
    }
    
}
