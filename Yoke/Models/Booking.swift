//
//  Booking.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/6/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Booking {
    var id: String?
    var uid: String?
    var fromUid: String
    var detail: String?
    var date: String?
    var startTime: String?
    var endTime: String?
    var location: String?
    var timestamp: Date
    var allowsRSVP: Bool?
    var allowsContact: Bool?

    init(dictionary: [String: Any]) {
        self.id = dictionary[Constants.Id] as? String ?? ""
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        self.fromUid = dictionary[Constants.FromUid] as? String ?? ""
        self.detail = dictionary[Constants.Detail] as? String ?? ""
        self.date = dictionary[Constants.Date] as? String ?? ""
        self.startTime = dictionary[Constants.StartTime] as? String ?? ""
        self.endTime = dictionary[Constants.EndTime] as? String ?? ""
        self.location = dictionary[Constants.Location] as? String ?? ""
        let secondsFrom1970 = dictionary[Constants.Timestamp] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
        self.allowsRSVP = dictionary[Constants.AllowsRSVP] as? Bool ?? false
        self.allowsContact = dictionary[Constants.AllowsContact] as? Bool ?? false
    }
}

extension Booking: Equatable {
    static func == (lhs: Booking, rhs: Booking) -> Bool {
        return lhs.id == rhs.id
    }
}
