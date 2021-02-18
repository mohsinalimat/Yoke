//
//  Review.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/18/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Review {
    var id: String?
    var uid: String?
    var name: String?
    var review: String?
    var stars: Double?
    var timestamp: String?

    init(id: String?, uid: String?, name: String?, review: String?, stars: Double?, timestamp: String?) {
        self.id = id
        self.uid = uid
        self.name = name
        self.review = review
        self.stars = stars
        self.timestamp = timestamp
    }
}

extension Review: Equatable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        return lhs.id == rhs.id
    }
}