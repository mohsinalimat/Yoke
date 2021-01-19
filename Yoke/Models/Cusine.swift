//
//  Cusine.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Cusine {
    var type: String
    var dictionary:[String:Any] {
        return ["type": type]
    }
    init(dictionary: [String:Any]) {
        self.type = dictionary["type"] as? String ?? "No Value"
    }
}
