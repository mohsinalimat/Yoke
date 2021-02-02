//
//  SuggestedChefController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import Firebase

class SuggestedChefController {
    //MARK: - Shared Instance
    static let shared = SuggestedChefController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Users)
    let storageRef = Storage.storage().reference().child(Constants.MenuImage)
    
    //MARK: - Source of truth
    var users: [User] = []
    
    //MARK: - CRUD Functions
    func fetchSuggestedChefsWith(uid: String, location: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    
}
