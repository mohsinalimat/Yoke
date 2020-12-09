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
    let uid: String
    let id: String
    let customer_id: String
    let email: String
    let username: String
    let profileImageUrl: String
    let ProfileCoverUrl: String
    let location: String
    let aboutUser: String
    let chefExperience: String
    let cusine: String
    let stars: Dictionary<String, Any>?
    var ratings: Double
    var availableDate = [String]()
    var hasRated: Bool?
    var isChef: Bool?
    var isSaved = false
    let bookmarkCount: Int?
    let userRate: Int?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.id = dictionary[Constants.Id] as? String ?? ""
        self.customer_id = dictionary["customer_id"] as? String ?? ""
        self.email = dictionary[Constants.Email] as? String ?? ""
        self.username = dictionary[Constants.Username] as? String ?? ""
        self.profileImageUrl = dictionary[Constants.ProfileImageUrl]  as? String ?? ""
        self.ProfileCoverUrl = dictionary[Constants.ProfileCoverUrl]  as? String ?? ""
        self.location = dictionary[Constants.Location] as? String ?? ""
        self.aboutUser = dictionary[Constants.About] as? String ?? ""
        self.chefExperience = dictionary[Constants.Experience] as? String ?? ""
        self.cusine = dictionary[Constants.Cusine] as? String ?? ""
        self.stars = dictionary[Constants.Stars] as? Dictionary<String, Any>
        self.ratings = dictionary[Constants.Ratings] as? Double ?? 0
        self.availableDate = [dictionary[Constants.BlackoutDate] as? String ?? ""]
        self.bookmarkCount = dictionary[Constants.BookmarkCount] as? Int
        self.userRate = dictionary[Constants.UserRate] as? Int
        self.isChef = dictionary[Constants.IsChef] as? Bool
        if let currentUserId = Auth.auth().currentUser?.uid {
            if self.stars != nil {
                self.hasRated = self.stars![currentUserId] != nil
            }
        }
        
    }
    
//    static func modelToData(user: User) -> [String: Any] {
//        let data : [String: Any] = [Constants.Uid: user.uid, Constants.Email: user.email, Constants.StripeId: user.stripeId]
//        return data
//    }
    
}
