//
//  MenuController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MenuController {
    
    //MARK: - Shared Instance
    static let shared = MenuController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore()
    
    //MARK: - Source of truth
    var menus: [Menu] = []
    
    //MARK: - CRUD Functions

}
