//
//  User.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class User {
    let uid: String?
    let id: String?
    let customer_id: String?
    let email: String?
    let username: String?
    let profileImageUrl: String?
    let profileCoverUrl: String?
    let location: String?
//    let aboutUser: String
//    let chefExperience: String
//    let cusine: String
//    let stars: Dictionary<String, Any>?
//    var ratings: Double
//    var availableDate = [String]()
//    var hasRated: Bool?
    var isChef: Bool?
//    var isSaved = false
//    let bookmarkCount: Int?
//    let userRate: Int?
    
    init(uid: String = "", id: String = "", customer_id: String = "", email: String = "", username: String = "", profileImageUrl: String = "", profileCoverUrl: String = "", location: String = "", isChef: Bool = false) {
        self.uid = uid
        self.id = id
        self.customer_id = customer_id
        self.email = email
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.profileCoverUrl = profileCoverUrl
        self.location = location
        self.isChef = isChef
    }
    
//    init(uid: String, id: String, customer_id: String, email: String, username: String, profileImageUrl: String, dictionary: [String: Any]) {
//        self.uid = uid
//        self.id = dictionary[Constants.Id] as? String ?? ""
//        self.customer_id = dictionary["customer_id"] as? String ?? ""
//        self.email = dictionary[Constants.Email] as? String ?? ""
//        self.username = dictionary[Constants.Username] as? String ?? ""
//        self.profileImageUrl = dictionary[Constants.ProfileImageUrl]  as? String ?? ""
//        self.profileCoverUrl = dictionary[Constants.ProfileCoverUrl]  as? String ?? ""
//        self.location = dictionary[Constants.Location] as? String ?? ""
//        self.aboutUser = dictionary[Constants.About] as? String ?? ""
//        self.chefExperience = dictionary[Constants.Experience] as? String ?? ""
//        self.cusine = dictionary[Constants.Cusine] as? String ?? ""
//        self.stars = dictionary[Constants.Stars] as? Dictionary<String, Any>
//        self.ratings = dictionary[Constants.Ratings] as? Double ?? 0
//        self.availableDate = [dictionary[Constants.BlackoutDate] as? String ?? ""]
//        self.bookmarkCount = dictionary[Constants.BookmarkCount] as? Int
//        self.userRate = dictionary[Constants.UserRate] as? Int
//        self.isChef = dictionary[Constants.IsChef] as? Bool
//        if let currentUserId = Auth.auth().currentUser?.uid {
//            if self.stars != nil {
//                self.hasRated = self.stars![currentUserId] != nil
//            }
//        }
//
//    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
