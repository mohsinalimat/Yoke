//
//  CusineController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CusineController {
    
    //MARK: - Shared Instance
    static let shared = CusineController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore()
    
    //MARK: - Source of truth
    var cusines: [Cusine] = []
    
    //MARK: - CRUD Functions
    func addCusineWith(uid: String, type: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.collection(Constants.Cusine).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                self.firestoreDB.collection(Constants.Cusine).document(uid).updateData([Constants.Cusine: FieldValue.arrayUnion([type])]) { error in
                    if let error = error {
                        completion(false)
                        print("error in add cusine: \(error.localizedDescription)")
                    } else {
                        completion(true)
                    }
                }
            } else {
                self.firestoreDB.collection(Constants.Cusine).document(uid).setData([Constants.Cusine: FieldValue.arrayUnion([type])]) { error in
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
    
    func deleteCusineWith(uid: String, type: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.collection(Constants.Cusine).document(uid).updateData([Constants.Cusine: FieldValue.arrayRemove([type])]) { error in
            if let error = error {
                completion(false)
                print("error in add cusine: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }
    
    func fetchCusineWith(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.collection(Constants.Cusine).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let array = document.data()?["cusine"] as? [String] else { return }
                for name in array {
//                    print(name)
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

        
}
