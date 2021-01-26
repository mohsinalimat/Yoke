//
//  Menu.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
class Menu {
    var type: [String]

    init(type: [String]) {
        self.type = type
    }
}

extension Menu: Equatable {
    static func == (lhs: Menu, rhs: Menu) -> Bool {
        return lhs.type == rhs.type
    }
}
