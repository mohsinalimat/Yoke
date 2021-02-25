//
//  Message.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

struct Message {
    let text: String
    let isFromCurrentUser: Bool
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
        return message.isFromCurrentUser ? .lightGray : .white
    }
}
