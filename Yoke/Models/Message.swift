//
//  Message.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

struct Message {
    let text: String
    let toId: String
    let fromId: String
    let timestamp: Timestamp!
    var user: User?
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary[Constants.Text] as? String ?? ""
        self.toId = dictionary[Constants.ToId] as? String ?? ""
        self.fromId = dictionary[Constants.FromId] as? String ?? ""
        self.timestamp = dictionary[Constants.Timestamp] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
    
}

struct MessageViewModel {
    
    private let message: Message
    init(message: Message) {
        self.message = message
    }
    
    var messageBackgroundColor: UIColor {
        guard let yellow = UIColor.yellowColor(),
              let orange = UIColor.orangeColor() else { return UIColor() }
        return message.isFromCurrentUser ? yellow : orange
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .darkGray : .white
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
   
}
