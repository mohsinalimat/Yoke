//
//  Message.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import MessageKit

struct Message {
    
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String
    var toId: String
    
    var dictionary: [String: Any] {
        return [Constants.Id: id, Constants.Content: content, Constants.Created: created, Constants.SenderID: senderID, "senderName":senderName, Constants.ToId: toId]
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary[Constants.Id] as? String,
            let content = dictionary[Constants.Content] as? String,
            let created = dictionary[Constants.Created] as? Timestamp,
            let senderID = dictionary[Constants.SenderID] as? String,
            let senderName = dictionary["senderName"] as? String,
            let toId = dictionary[Constants.ToId] as? String
            else { return nil }
        
        self.init(id: id, content: content, created: created, senderID: senderID, senderName: senderName, toId: toId)
    }
}

extension Message: MessageType {
    
    var sender: SenderType {
        return Sender(id: senderID, displayName: "")
    }
    var messageId: String {
        return id
    }
    var sentDate: Date {
        return created.dateValue()
    }
    var kind: MessageKind {
        return .text(content)
    }
}

struct Chat {
    var users: [String]
    var dictionary: [String: Any] {
        return [
            Constants.Users: users
        ]
    }
}

extension Chat {
    
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary[Constants.Users] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
    
}

