//
//  Gallery.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import Firebase

class Gallery {
    let user: User
    var id: String?
    var bookmarkedUser: String?
    var imageUrl: String?
    var caption: String?
    var location: String?
    var likes: Dictionary<String, Any>?
    var likeCount: Int?
    var isLiked: Bool?
    var creationDate: Date
    var hasLiked = false
    
    init(user: User, id: String, bookmarkedUser: String = "", imageUrl: String = "", caption: String = "", location: String = "", likes: Dictionary<String, Any>, likeCount: Int = 0, isLiked: Bool = false, creationDate: Date) {
        self.user = user
        self.id = id
        self.bookmarkedUser = bookmarkedUser
        self.imageUrl = imageUrl
        self.caption = caption
        self.location = location
        self.likeCount = likeCount
        self.isLiked = isLiked
        self.creationDate = creationDate
        if let currentUserId = Auth.auth().currentUser?.uid {
            if self.likes != nil {
                self.isLiked = self.likes![currentUserId] != nil
            }
        }
    }
    
//    init(user: User, dictionary: [String: Any]) {
//        self.user = user
//        self.id = dictionary[Constants.Id] as? String ?? ""
//        self.BookmarkedUser = dictionary[Constants.BookmarkedUser] as? String ?? ""
//        self.imageUrl = dictionary[Constants.ImageUrl] as? String ?? ""
//        self.caption = dictionary[Constants.Caption] as? String ?? ""
//        self.location = dictionary[Constants.Location] as? String ?? ""
//        self.likes = dictionary[Constants.Likes] as? Dictionary<String, Any>
//        self.likeCount = dictionary[Constants.LikeCount] as? Int
//        let secondsFrom1970 = dictionary[Constants.CreationDate] as? Double ?? 0
//        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
//        if let currentUserId = Auth.auth().currentUser?.uid {
//            if self.likes != nil {
//                self.isLiked = self.likes![currentUserId] != nil
//            }
//        }
//    }
    
}

extension Gallery: Equatable {
    static func == (lhs: Gallery, rhs: Gallery) -> Bool {
        return lhs.id == rhs.id
    }
}
