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
    let firestoreDB = Firestore.firestore().collection(Constants.Users)
    
    //MARK: - CRUD Functions
    func blockUserWith(userBlockingUid: String, userToBlockUid: String, isBlocked: Bool, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(userBlockingUid).collection(Constants.Blocked).document(userToBlockUid).setData([userToBlockUid: isBlocked], merge: false)
        firestoreDB.document(userToBlockUid).collection(Constants.BlockedBy).document(userBlockingUid).setData([userBlockingUid: isBlocked], merge: false)
    }
    
    func checkIfBlockedWith(userBlockingUid: String, userToBlockUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(userBlockingUid).collection(Constants.Blocked).whereField(userToBlockUid, isEqualTo: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            print(true)
            completion(true)
        }
        firestoreDB.document(userBlockingUid).collection(Constants.Blocked).whereField(userToBlockUid, isEqualTo: false).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            print(false)
            completion(true)
        }
//        firestoreDB.document(userBlockingUid).collection(Constants.Blocked).document(userToBlockUid).addSnapshotListener { snapshot, error in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(false)
//            }
//            guard let dictionary = snapshot?.data() else { return }
//            let isBlocked = dictionary as? Bool
//            if isBlocked == true {
//                print("is blocked true")
//            } else {
//                print("is blocked false")
//            }
//            completion(true)
//        }
    }
}
