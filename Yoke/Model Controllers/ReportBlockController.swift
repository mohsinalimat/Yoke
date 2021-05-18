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
    
    func checkIfBlockedWith(userBlockingUid: String, userToBlockUid: String, isBlocked: Bool, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(userBlockingUid).collection(Constants.Blocked).document(userToBlockUid).setData([userToBlockUid: isBlocked], merge: false)
        firestoreDB.document(userToBlockUid).collection(Constants.BlockedBy).document(userBlockingUid).setData([userBlockingUid: isBlocked], merge: false)
    }
}
