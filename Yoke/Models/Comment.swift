//
//  Comment.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
struct Comment {
    
    var id: String?
    
    let user: User
    
    let text: String
    let uid: String
    let creationDate: Date?
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary[Constants.Text] as? String ?? ""
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        
        let secondsFrom1970 = dictionary[Constants.CreationDate] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
