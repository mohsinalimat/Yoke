//
//  Notifications.swift
//  FooD
//
//  Created by LAURA JELENICH on 4/9/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class Notifications: NSObject {

    var key: String!
    let user: User
    var fromId: String?
    var toId: String?
    var message: String?
    var reference: String?
    var notificationType: String?
    var creationDate: Date?
    var timestamp: NSNumber?
    
    init(user: User, dictionary: [String: Any], snapshot: DataSnapshot) {
        self.key = snapshot.key
        self.user = user
        self.fromId = dictionary[Constants.FromId] as? String
        self.message = dictionary[Constants.Message] as? String
        self.notificationType = dictionary["notificationType"] as? String
        self.reference = dictionary["reference"] as? String
        self.toId = dictionary[Constants.ToId] as? String
        let secondsFrom1970 = dictionary[Constants.CreationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    
//    func chatPartnerId() -> String? {
//        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
//    }
    
}
