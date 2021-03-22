//
//  Event.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/22/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Event {
    var id: String?
    var uid: String?
    var username: String?
    var eventImageUrl: String?
    var caption: String?
    var detail: String?
    var date: String?
    var time: String?
    var location: String?
    var timestamp: Date

    init(dictionary: [String: Any]) {
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        self.username = dictionary[Constants.Username] as? String ?? ""
        self.eventImageUrl = dictionary[Constants.EventImageUrl] as? String ?? ""
        self.caption = dictionary[Constants.Caption] as? String ?? ""
        self.detail = dictionary[Constants.Detail] as? String ?? ""
        self.date = dictionary[Constants.Date] as? String ?? ""
        self.time = dictionary[Constants.Time] as? String ?? ""
        self.location = dictionary[Constants.Location] as? String ?? ""
        let secondsFrom1970 = dictionary[Constants.Timestamp] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
