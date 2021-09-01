//
//  EventViewModel.swift
//  Yoke
//
//  Created by LAURA JELENICH on 9/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

struct EventViewModel {
    let caption: String
    let location: String
    let date: String
    let startTime: String
    let endTime: String
    let timestamp: String
    let image: String
    let uid: String
    let username: String
    
    init(event: Event, user: User) {
        self.caption = event.caption
        self.location = event.location
        self.date = event.date
        self.starTime = event.startTime
        self.endTime = event.endTime
        self.timestamp = event.timestamp
        self.image = event.eventImageUrl
        UserController.shared.fetchUserWithUID(uid: user.uid) { (user) in
            self.username = username
//            guard let image = user.profileImageUrl,
//                  let username = user.username else { return }
//            self.profileImage.loadImage(urlString: image)
//            self.usernameLabel.text = "Posted by: \(username)"
        }
    }
}
