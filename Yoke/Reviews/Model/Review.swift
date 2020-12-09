//
//  Review.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation

struct Review {
    
    var id: String?
    
    let user: User
    
    let text: String
    let uid: String
    let creationDate: Date?
    let ratings: Double!
//    let ratings: Int!
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
//        self.ratings = dictionary[Constants.Ratings] as? Int
        let getRatings = dictionary[Constants.Ratings] as? Double ?? 0
        self.ratings = Double(getRatings)
        
        let secondsFrom1970 = dictionary[Constants.CreationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
