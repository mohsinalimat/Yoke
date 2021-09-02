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
    func createRSVPWith(uid: String, eventUserUid: String, eventId: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.RSVP).document(eventId).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.document(uid).collection(Constants.RSVP).document(eventId).delete()
                completion(true)
            } else {
                self.firestoreDB.document(uid).collection(Constants.RSVP).document(eventId).setData([Constants.Id: eventId, Constants.UserUid: uid, Constants.AcceptRSVP: true, Constants.ChefUid: eventUserUid], merge: true)
                completion(false)
            }
        }
    }
    
    func checkIfEventIsRSVP(uid: String, eventId: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.RSVP).document(eventId).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            if let data = document.data() {
                print(data)
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
