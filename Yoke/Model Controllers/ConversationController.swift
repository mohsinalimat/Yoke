//
//  ConversationController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import FirebaseFirestore
import FirebaseAuth

class ConversationController {
    
    //MARK: - Shared Instance
    static let shared = ConversationController()
    
    //MARK: - Source of truth
    var messages: [Message] = []
    var conversations = [Conversation]()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Messages)
    
    //MARK: - CRUD Functions
    func uploadMessage(_ message: String, to userUid: String, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let data = [Constants.Text: message, Constants.FromId: currentUid, Constants.ToId: userUid, Constants.Timestamp: Date().timeIntervalSince1970] as [String: Any]
        firestoreDB.document(currentUid).collection(userUid).addDocument(data: data) { _ in
            self.firestoreDB.document(userUid).collection(currentUid).addDocument(data: data, completion: completion)
            self.firestoreDB.document(currentUid).collection(Constants.RecentMessages).document(userUid).setData(data)
            self.firestoreDB.document(userUid).collection(Constants.RecentMessages).document(currentUid).setData(data)
        }
    }
    
    func fetchMessages(userUid: String, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        firestoreDB.document(currentUid).collection(userUid).order(by: Constants.Timestamp).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }

  
 
    func fetchConversations(completion: @escaping ([Conversation]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
//        self.conversations = []
        firestoreDB.document(uid).collection(Constants.RecentMessages).order(by: Constants.Timestamp).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            self.conversations = []
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                UserController.shared.fetchUserWithUID(uid: message.toId) { user in
                    let conversation = Conversation(user: user, message: message)
                    self.conversations.append(conversation)
                    completion(self.conversations)
                }
            })
        }
    }
    
    func deleteConversation(chatParnterId: String, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = firestoreDB.document(uid).collection(Constants.RecentMessages)
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            query.document(chatParnterId).delete()
            completion(true)
        }
    }
}
