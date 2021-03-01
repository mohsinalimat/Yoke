//
//  ConversationController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

struct ConversationController {
    //MARK: - Shared Instance
    static let shared = ConversationController()

    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Messages)

    //MARK: - Source of truth
    

    //MARK: - CRUD Functions
    func uploadMessage(_ message: String, to userUid: String, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//        let data = [Constants.Text: message, Constants.FromId: currentUid, Constants.ToId: userUid, Constants.Timestamp: Timestamp(date: Date())] as [String: Any]
        let data = [Constants.Text: message, Constants.FromId: currentUid, Constants.ToId: userUid, Constants.Timestamp: Date().timeIntervalSince1970] as [String: Any]
        firestoreDB.document(currentUid).collection(userUid).addDocument(data: data) { _ in
            firestoreDB.document(userUid).collection(currentUid).addDocument(data: data, completion: completion)
            firestoreDB.document(currentUid).collection(Constants.RecentMessages).document(userUid).setData(data)
            firestoreDB.document(userUid).collection(Constants.RecentMessages).document(currentUid).setData(data)
        }
    }
    
    func fetchMessages(forUser: String, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let query = firestoreDB.document(currentUid).collection(forUser).order(by: Constants.Timestamp)
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            snapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dictionary = change.document.data()
                    let message = Message(dictionary: dictionary)
                    messages.append(message)
                    completion(messages)
                }
            })
        }
    }
    
    func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = firestoreDB.document(uid).collection(Constants.RecentMessages).order(by: Constants.Timestamp)
        
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            snapshot?.documentChanges.forEach({ (change) in
                let dictionary = change.document.data()
                print(dictionary)
                let message = Message(dictionary: dictionary)
                UserController.shared.fetchUserWithUID(uid: message.chatPartnerId) { (user) in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    func deleteConversation(currentUserUid: String, userUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(currentUserUid).collection(userUid).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                for document in snapshot!.documents {
                  document.reference.delete()
                    firestoreDB.document(currentUserUid).collection(Constants.RecentMessages).document(userUid).delete()
                    completion(true)
                }
            }
        }
    }
}
