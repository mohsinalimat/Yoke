//
//  Message.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class Message {
    let text: String
    let toId: String
    let fromId: String
    var timestamp: Date
    var user: User?
    let isFromCurrentUser: Bool
    
    var chatPartnerId: String {
        return isFromCurrentUser ? toId : fromId
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary[Constants.Text] as? String ?? ""
        self.toId = dictionary[Constants.ToId] as? String ?? ""
        self.fromId = dictionary[Constants.FromId] as? String ?? ""
        let secondsFrom1970 = dictionary[Constants.Timestamp] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
    
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.toId == rhs.toId
    }
}

//class Conversation {
//    let user: User
//    let message: Message
//    init(user: User, message: Message, dictionary: [String: Any]) {
//        self.user = user
//        self.message = message
//    }
//}
//
//extension Conversation: Equatable {
//    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
//        return lhs.message.toId == rhs.message.toId
//    }
//}

struct MessageViewModel {
    
    private let message: Message
    init(message: Message) {
        self.message = message
    }
    
    var timestamp: String {
        let date = message.timestamp
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter.string(from: date)
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

//struct ConversationViewModel {
//    private let conversation: Conversation
//    var timestamp: String {
//        let date = conversation.message.timestamp
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .short
//        return dateFormatter.string(from: date)
//    }
//    init(conversation: Conversation) {
//        self.conversation = conversation
//    }
//}
