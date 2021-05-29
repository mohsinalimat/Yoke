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
    
    //MARK: - CRUD Functions
    func bookmarkUserWith(uid: String, bookmarkedUid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.BookmarkedUser).document(bookmarkedUid).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.document(uid).collection(Constants.BookmarkedUser).document(bookmarkedUid).delete()
                completion(true)
            } else {
                self.firestoreDB.document(uid).collection(Constants.BookmarkedUser).document(bookmarkedUid).setData([bookmarkedUid: true], merge: false)
                completion(false)
                print("Document does not exist")
            }
        }
    }
    
    func bookmarkEventWith(uid: String, eventId: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.BookmarkedEvents).document(eventId).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.document(uid).collection(Constants.BookmarkedUser).document(eventId).delete()
                completion(true)
            } else {
                self.firestoreDB.document(uid).collection(Constants.BookmarkedUser).document(eventId).setData([eventId: true], merge: false)
                completion(false)
                print("Document does not exist")
            }
        }
    }
}