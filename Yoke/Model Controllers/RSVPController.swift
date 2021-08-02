//
//  RSVPController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 8/2/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import FirebaseFirestore

class RSVPController {
    //MARK: - Shared Instance
    static let shared = RSVPController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.RSVP)
    
    //MARK: - Source of truth
    var eventsRSVP: [EventRSVP] = []
    
    //MARK: - CRUD Functions
    func createRSVPWith(uid: String, completion: @escaping (Bool) -> Void) {
        
    }
}
