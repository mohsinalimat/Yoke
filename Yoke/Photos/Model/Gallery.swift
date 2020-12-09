//
//  Gallery.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import Firebase


struct Gallery {
    
    let user: User
    var id: String?
    let BookmarkedUser: String?
    let imageUrl: String
    let caption: String?
    let location: String?
    let likes: Dictionary<String, Any>?
    let likeCount: Int?
    var isLiked: Bool?
    let creationDate: Date
    
    var hasLiked = false
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.id = dictionary[Constants.Id] as? String ?? ""
        self.BookmarkedUser = dictionary[Constants.BookmarkedUser] as? String ?? ""
        self.imageUrl = dictionary[Constants.ImageUrl] as? String ?? ""
        self.caption = dictionary[Constants.Caption] as? String ?? ""
        self.location = dictionary[Constants.Location] as? String ?? ""
        self.likes = dictionary[Constants.Likes] as? Dictionary<String, Any>
        self.likeCount = dictionary[Constants.LikeCount] as? Int
        let secondsFrom1970 = dictionary[Constants.CreationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        if let currentUserId = Auth.auth().currentUser?.uid {
            if self.likes != nil {
                self.isLiked = self.likes![currentUserId] != nil
            }
        }
    }
    
}
