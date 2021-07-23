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
    
    //MARK: - Source of truth
//    var messages: [Message] = []
    var conversationDictionary = [String: Conversation]()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Messages)
    
    //MARK: - CRUD Functions
    func uploadMessage(_ message: String, to userUid: String, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let data = [Constants.Text: message, Constants.FromId: currentUid, Constants.ToId: userUid, Constants.Timestamp: Date().timeIntervalSince1970] as [String: Any]
        firestoreDB.document(currentUid).collection(userUid).addDocument(data: data) { _ in
            firestoreDB.document(userUid).collection(currentUid).addDocument(data: data, completion: completion)
            firestoreDB.document(currentUid).collection(Constants.RecentMessages).document(userUid).setData(data)
            firestoreDB.document(userUid).collection(Constants.RecentMessages).document(currentUid).setData(data)
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
 
    func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        firestoreDB.document(uid).collection(Constants.RecentMessages).order(by: Constants.Timestamp).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            conversations = []
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                UserController.shared.fetchUserWithUID(uid: message.toId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    func deleteConversation(chatParnterId: String, completion: @escaping ([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = firestoreDB.document(uid).collection(Constants.RecentMessages)
        conversations = []
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            }
            query.document(chatParnterId).delete()
            completion(conversations)
        }
    }
}
