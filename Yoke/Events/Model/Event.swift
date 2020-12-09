//
//  Event.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Event {
    
    var key: String!
    var id: String?
    
    let user: User
    let uid: String?
    let username: String?
    let imageUrl: String?
    let eventImageUrl: String?
    let caption: String?
    let postText: String?
    let eventDate: String?
    let creationDate: Date?
    let startTime: String?
    let endTime: String?
    let address: String?
    let bookmarkCount: Int?
    
    var isSaved = false
    var hasSaved = false
    
    init(user: User, dictionary: [String: Any], snapshot: DataSnapshot) {
        self.key = snapshot.key
        self.user = user
        self.id = dictionary[Constants.Id] as? String ?? ""
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        self.username = dictionary[Constants.Username] as? String ?? ""
        self.imageUrl = dictionary[Constants.ImageUrl] as? String ?? ""
        self.eventImageUrl = dictionary[Constants.EventImageUrl] as? String ?? ""
        self.caption = dictionary[Constants.Caption] as? String ?? ""
        self.postText = dictionary[Constants.PostText] as? String ?? ""
        self.eventDate = dictionary[Constants.EventDate] as? String ?? ""
        self.startTime = dictionary[Constants.StartTime] as? String ?? ""
        self.endTime = dictionary[Constants.EndTime] as? String ?? ""
        self.address = dictionary[Constants.Address] as? String ?? ""
        self.bookmarkCount = dictionary[Constants.BookmarkCount] as? Int
        
//        let secondsFrom1970 = dictionary[Constants.EventDate] as? Double ?? 0
//        self.eventDate = Date(timeIntervalSince1970: secondsFrom1970)
        
        let secondsFrom1970CD = dictionary[Constants.CreationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970CD)
    }
    
}

