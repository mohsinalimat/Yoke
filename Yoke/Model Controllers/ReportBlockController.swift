//
//  ReportBlockController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 5/18/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import Firebase

class ReportBlockController {
    //MARK: - Shared Instance
    static let shared = ReportBlockController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Blocked)
    
    //MARK: - CRUD Functions
    func blockUserWith(userBlockingUid: String, userToBlockUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(userBlockingUid).collection(Constants.Blocked).document(userToBlockUid).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.document(userBlockingUid).collection(Constants.Blocked).document(userToBlockUid).delete()
                completion(true)
            } else {
                self.firestoreDB.document(userBlockingUid).collection(Constants.Blocked).document(userToBlockUid).setData([userToBlockUid: true], merge: false)
                completion(false)
                print("Document does not exist")
            }
        }
        firestoreDB.document(userToBlockUid).collection(Constants.BlockedBy).document(userBlockingUid).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.document(userToBlockUid).collection(Constants.BlockedBy).document(userBlockingUid).delete()
                completion(true)
            } else {
                self.firestoreDB.document(userToBlockUid).collection(Constants.BlockedBy).document(userBlockingUid).setData([userBlockingUid: true], merge: false)
                completion(false)
                print("Document does not exist")
            }
        }
    }
    
    func checkIfBlockedBy(userBlockingUid: String, userToBlockUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(userToBlockUid).collection(Constants.BlockedBy).document(userBlockingUid).getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
                print("Document does not exist")
            }
        }
    }
    
    func checkIfBlocked(userBlockingUid: String, userToBlockUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(userBlockingUid).collection(Constants.Blocked).document(userToBlockUid).getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
}
