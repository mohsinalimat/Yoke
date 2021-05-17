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
    var imageId: String?
    var caption: String?
    var detail: String?
    var date: String?
    var startTime: String?
    var endTime: String?
    var location: String?
    var shortLocation: String?
    var timestamp: Date
    var allowsRSVP: Bool?
    var allowsContact: Bool?

    init(dictionary: [String: Any]) {
        self.id = dictionary[Constants.Id] as? String ?? ""
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        self.username = dictionary[Constants.Username] as? String ?? ""
        self.eventImageUrl = dictionary[Constants.EventImageUrl] as? String ?? ""
        self.imageId = dictionary[Constants.Id] as? String ?? ""
        self.caption = dictionary[Constants.Caption] as? String ?? ""
        self.detail = dictionary[Constants.Detail] as? String ?? ""
        self.date = dictionary[Constants.Date] as? String ?? ""
        self.startTime = dictionary[Constants.StartTime] as? String ?? ""
        self.endTime = dictionary[Constants.EndTime] as? String ?? ""
        self.location = dictionary[Constants.Location] as? String ?? ""
        self.shortLocation = dictionary[Constants.ShortLocation] as? String ?? ""
        let secondsFrom1970 = dictionary[Constants.Timestamp] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
        self.allowsRSVP = dictionary[Constants.AllowsRSVP] as? Bool ?? false
        self.allowsContact = dictionary[Constants.AllowsContact] as? Bool ?? false
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
