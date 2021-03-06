//
//  Review.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/18/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Review {
    var id: String?
    var uid: String?
    var username: String?
    var review: String?
    var stars: Double?
    var timestamp: Date
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        self.username = dictionary[Constants.Username] as? String ?? ""
        self.review = dictionary[Constants.Review] as? String ?? ""
        self.stars = dictionary[Constants.Ratings] as? Double ?? 0.0
        let secondsFrom1970 = dictionary[Constants.Timestamp] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

extension Review: Equatable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id
    }
}
