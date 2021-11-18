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
            return "\(secondsAgo) seconds ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) minutes"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hours"
        } else if secondsAgo < week {
            return "\(secondsAgo / day) days"
        }
        
        return dateFormatter.string(from: date)
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
