//
//  Message001.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//
import UIKit
import Firebase

class Message001: NSObject {

    var fromId: String?
    var toId: String?
    var text: String?
    var creationDate: Date?
    var timestamp: NSNumber?
    var imageUrl: String?
    var videoUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary[Constants.FromId] as? String
        self.text = dictionary[Constants.PostText] as? String
        self.toId = dictionary[Constants.ToId] as? String
        self.imageUrl = dictionary[Constants.ImageUrl] as? String
        self.videoUrl = dictionary[Constants.VideoUrl] as? String
        self.imageWidth = dictionary[Constants.Width] as? NSNumber
        self.imageHeight = dictionary[Constants.Height] as? NSNumber
        let secondsFrom1970 = dictionary[Constants.CreationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    
}
