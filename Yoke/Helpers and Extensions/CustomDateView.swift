//
//  CustomDateView.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let date = Date(timeIntervalSince1970: TimeInterval(secondsAgo))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        
        
        if secondsAgo < minute {
            //            return "Less then a minute"
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days"
        }
        
        return dateFormatter.string(from: date)
        //        return "\(secondsAgo / week) weeks"
    }
}
