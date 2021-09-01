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
    let time: String
    let timestamp: String
    let image: String
    
    init(event: Event) {
        self.caption = event.caption
        self.location = event.location
        self.date = event.date
        self.time = event.timestamp
        self.timestamp = event.timestamp
        self.image = event.eventImageUrl
    }
}
