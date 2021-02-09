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
    let uid: String
//    let uid: String
    var id: String?
    var imageUrl: String?
    var caption: String?
    var location: String?
//    var likes: Dictionary<String, Any>?
    var likeCount: Int?
    var isLiked: Bool?
    var timestamp: String
    var hasLiked = false
    
    init(uid: String, id: String = "", imageUrl: String = "", caption: String = "", location: String = "", likeCount: Int = 0, isLiked: Bool = false, timestamp: String) {
        self.uid = uid
        self.id = id
        self.imageUrl = imageUrl
        self.caption = caption
        self.location = location
        self.likeCount = likeCount
        self.isLiked = isLiked
        self.timestamp = timestamp
//        if let currentUserId = Auth.auth().currentUser?.uid {
//            if self.likes != nil {
//                self.isLiked = self.likes![currentUserId] != nil
//            }
//        }
    }
}

extension Gallery: Equatable {
    static func == (lhs: Gallery, rhs: Gallery) -> Bool {
        return lhs.id == rhs.id
    }
}
