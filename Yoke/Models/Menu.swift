//
//  Menu.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
class Menu {
//    var user: User
    var id: String?
    var uid: String?
    var name: String?
    var detail: String?
    var courseType: String?
    var menuType: String?
    var imageUrl: String?
    var imageId: String?

    init(dictionary: [String: Any]) {
//        self.user = user
        self.id = dictionary[Constants.Id] as? String ?? ""
        self.uid = dictionary[Constants.Uid] as? String ?? ""
        self.name = dictionary[Constants.Name] as? String ?? ""
        self.detail = dictionary[Constants.Detail] as? String ?? ""
        self.courseType = dictionary[Constants.CourseType] as? String ?? ""
        self.menuType = dictionary[Constants.MenuType] as? String ?? ""
        self.imageUrl = dictionary[Constants.ImageUrl] as? String ?? ""
        self.imageId = dictionary[Constants.ImageId] as? String ?? ""
    }
}

extension Menu: Equatable {
    static func == (lhs: Menu, rhs: Menu) -> Bool {
        return lhs.id == rhs.id
    }
}
