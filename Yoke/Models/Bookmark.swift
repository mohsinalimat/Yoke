//
//  Bookmark.swift
//  Yoke
//
//  Created by LAURA JELENICH on 6/8/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
struct Bookmark {
    let user: User
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
    }
}
