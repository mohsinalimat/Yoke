//
//  Schedule.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Schedule {
    
    var key: String!
    let user: User
    let BookmarkedUser: String?
    var id: String?
    let eventKey: String
    let title: String
    let note: String
    let eventDate: String
    let availableDate: String
    let scheduleDate: String
    let startTime: String
    let endTime: String

    init(user: User, dictionary: [String: Any], snapshot: DataSnapshot) {
        self.key = snapshot.key
        self.user = user
        self.BookmarkedUser = dictionary[Constants.BookmarkedUser] as? String ?? ""
        self.id = dictionary[Constants.Id] as? String ?? ""
        self.eventKey = dictionary[Constants.Event] as? String ?? ""
        self.title = dictionary[Constants.Title] as? String ?? ""
        self.note = dictionary[Constants.Note] as? String ?? ""
        self.eventDate = dictionary[Constants.EventDate] as? String ?? ""
        self.availableDate = dictionary[Constants.AvailableDate] as? String ?? ""
        self.scheduleDate = dictionary[Constants.ScheduleDate] as? String ?? ""
        self.startTime = dictionary[Constants.StartTime] as? String ?? ""
        self.endTime = dictionary[Constants.EndTime] as? String ?? ""
//        let startDateFormatter = dictionary[Constants.SelectedDate] as? Double ?? 0
//        self.selectedDate = Date(timeIntervalSince1970: startDateFormatter)

    }
    
}
