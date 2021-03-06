//
//  CuisineController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CuisineController {
    
    //MARK: - Shared Instance
    static let shared = CuisineController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Chefs)
    
    //MARK: - Source of truth
    var cusines: [Cusine] = []
    
    //MARK: - CRUD Functions
    func addCusineWith(uid: String, type: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.document(uid).updateData([Constants.Cuisine: FieldValue.arrayUnion([type])]) { error in
                    if let error = error {
                        completion(false)
                        print("error in add cusine: \(error.localizedDescription)")
                    } else {
                        completion(true)
                    }
                }
            } else {
                self.firestoreDB.document(uid).setData([Constants.Cuisine: FieldValue.arrayUnion([type])]) { error in
                    if let error = error {
                        completion(false)
                        print("error in add cusine: \(error.localizedDescription)")
                    } else {
                        completion(true)
                    }
                }
                print("Document does not exist")
            }
        }
    }
    
    func fetchCusineWith(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let array = document.data()?["cuisine"] as? [String] else { return }
                for name in array {
                    let cusine = Cusine(type: [name])
                    self.cusines.append(cusine)
                }
                completion(true)
            } else {
                completion(false)
                print("Document does not exist")
            }
        }
    }
    
    func deleteCusineWith(uid: String, type: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).updateData([Constants.Cuisine: FieldValue.arrayRemove([type])]) { error in
            if let error = error {
                completion(false)
                print("error in add cuisine: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }
}
