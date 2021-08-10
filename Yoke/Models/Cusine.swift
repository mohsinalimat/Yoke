//
//  Cusine.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation

class Cusine {
    var type: [String]
    
    init(type: [String]) {
        self.type = type
    }
}

extension Cusine: Equatable {
    static func == (lhs: Cusine, rhs: Cusine) -> Bool {
        return lhs.type == rhs.type
    }
}
