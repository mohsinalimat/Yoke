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
    var chefUid: String?
    var userUid: String?
    var detail: String?
    var date: String?
    var startTime: String?
    var endTime: String?
    var location: String?
    var timestamp: Date
    var numberOfPeople: Int?
    var numberOfCourses: Int?
    var cusineType: String?
    var isBooked: Bool?
    var invoiceSent: Bool?
    var invoicePaid: Bool?

    init(dictionary: [String: Any]) {
        self.id = dictionary[Constants.Id] as? String ?? ""
        self.chefUid = dictionary[Constants.ChefUid] as? String ?? ""
        self.userUid = dictionary[Constants.UserUid] as? String ?? ""
        self.detail = dictionary[Constants.Detail] as? String ?? ""
        self.date = dictionary[Constants.Date] as? String ?? ""
        self.startTime = dictionary[Constants.StartTime] as? String ?? ""
        self.endTime = dictionary[Constants.EndTime] as? String ?? ""
        self.location = dictionary[Constants.Location] as? String ?? ""
        let secondsFrom1970 = dictionary[Constants.Timestamp] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
        self.numberOfPeople = dictionary[Constants.NumberOfPeople] as? Int ?? 0
        self.numberOfCourses = dictionary[Constants.NumberOfCourses] as? Int ?? 0
        self.cusineType = dictionary[Constants.CuisineType] as? String ?? ""
        self.isBooked = dictionary[Constants.IsBooked] as? Bool ?? false
        self.invoiceSent = dictionary[Constants.InvoiceSent] as? Bool ?? false
        self.invoicePaid = dictionary[Constants.InvoicePaid] as? Bool ?? false
    }
}

extension Booking: Equatable {
    static func == (lhs: Booking, rhs: Booking) -> Bool {
        return lhs.id == rhs.id
    }
}
