//
//  BookmarkController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 5/29/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import FirebaseFirestore

class BookmarkController {
    //MARK: - Shared Instance
    static let shared = BookmarkController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Bookmarks)
    
    //MARK: - Source of truth
    var events: [Event] = []
    var users: [User] = []
    
    //MARK: - CRUD Functions
    func bookmarkUserWith(uid: String, bookmarkedUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.BookmarkedUsers).document(bookmarkedUid).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.document(uid).collection(Constants.BookmarkedUsers).document(bookmarkedUid).delete()
                completion(true)
            } else {
                self.firestoreDB.document(uid).collection(Constants.BookmarkedUsers).document(bookmarkedUid).setData([bookmarkedUid: true], merge: false)
                completion(false)
            }
        }
    }
    
    func checkIfBookmarkedUserWith(uid: String, bookmarkedUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.BookmarkedUsers).document(bookmarkedUid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
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
    
    func fetchBookmarkedUserWith(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.BookmarkedUsers).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.users = []
            let doc = snapshot!.documents
            print("doc: \(doc)")
            Firestore.firestore().collection(Constants.Users).document(uid).addSnapshotListener { snapshot, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                }
            }
            guard error == nil, let snapshot = snapshot?.documentChanges else { return }
            snapshot.forEach {
                let doc = $0.document
                let documentId = doc.documentID
                Firestore.firestore().collection(Constants.Users).document(documentId).addSnapshotListener { snapshot, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    }
                    guard let dictionary = snapshot?.data() else { return }
                    let user = User(dictionary: dictionary)
                    self.users.append(user)
                    completion(true)
                }
            }
        }
    }
    
    func bookmarkEventWith(uid: String, eventId: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.BookmarkedEvents).document(eventId).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.document(uid).collection(Constants.BookmarkedEvents).document(eventId).delete()
                completion(true)
            } else {
                self.firestoreDB.document(uid).collection(Constants.BookmarkedEvents).document(eventId).setData([eventId: true], merge: false)
                completion(false)
            }
        }
    }
    
    func checkIfBookmarkedEventWith(uid: String, id: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.BookmarkedEvents).document(id).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
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
    
    func fetchBookmarkedEventWith(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.BookmarkedEvents).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.events = []
            snapshot?.documents.forEach({ (document) in
                let docId = document.documentID
                print("event bk \(docId)")
                Firestore.firestore().collection(Constants.Events).document(docId).addSnapshotListener { snapshot, error in
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false)
                    }
                    let dictionary = document.data()
                    print("event dic \(dictionary)")
                    let event = Event(dictionary: dictionary)
                    self.events.append(event)
                    completion(true)
                }
//                let dictionary = document.data()
//                let event = Event(dictionary: dictionary)
//                self.events.append(event)
//                completion(true)
            })
        }
    }
}

