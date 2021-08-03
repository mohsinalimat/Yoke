//
//  Conversation.swift
//  Yoke
//
//  Created by LAURA JELENICH on 8/3/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Conversation {
    let user: User
    let message: Message
    init(user: User, message: Message, dictionary: [String: Any]) {
        self.user = user
        self.message = message
    }
}

extension Conversation: Equatable {
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        return lhs.message.toId == rhs.message.toId
    }
}
