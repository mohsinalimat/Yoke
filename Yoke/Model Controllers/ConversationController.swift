//
//  ConversationController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Firebase

struct ConversationController {
    //MARK: - Shared Instance
    static let shared = ConversationController()

    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Messages)

    //MARK: - Source of truth
    

    //MARK: - CRUD Functions
    func uploadMessage(_ message: String, to userUid: String, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let data = [Constants.Text: message, Constants.FromId: currentUid, Constants.ToId: userUid, Constants.Timestamp: Timestamp(date: Date())] as [String: Any]
        firestoreDB.document(currentUid).collection(userUid).addDocument(data: data) { _ in
            firestoreDB.document(userUid).collection(currentUid).addDocument(data: data, completion: completion)
        }
    }
}
