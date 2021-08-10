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
    let customer_id: String?
    let email: String?
    let username: String?
    let profileImageUrl: String?
    let profileCoverUrl: String?
    let location: String?
    let bio: String?
    let street: String?
    let apartment: String?
    let city: String?
    let state: String?
    let latitude: Double?
    let longitude: Double?
    var stars: Int?
    var isChef: Bool?
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        self.customer_id = dictionary[Constants.CustomerId] as? String ?? ""
        self.email = dictionary[Constants.Email] as? String ?? ""
        self.username = dictionary[Constants.Username] as? String ?? ""
        self.profileImageUrl = dictionary[Constants.ProfileImageUrl] as? String ?? ""
        self.profileCoverUrl = dictionary[Constants.ProfileBannerUrl] as? String ?? ""
        self.bio = dictionary[Constants.Bio] as? String ?? ""
        self.location = dictionary[Constants.Location] as? String ?? ""
        self.street = dictionary[Constants.Street] as? String ?? ""
        self.apartment = dictionary[Constants.Apartment] as? String ?? ""
        self.city = dictionary[Constants.City] as? String ?? ""
        self.state = dictionary[Constants.State] as? String ?? ""
        self.latitude = dictionary[Constants.Latitude] as? Double ?? 0.0
        self.longitude = dictionary[Constants.Longitude] as? Double ?? 0.0
        self.stars = dictionary[Constants.Stars] as? Int ?? 0
        self.isChef = dictionary[Constants.IsChef] as? Bool
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }
}
