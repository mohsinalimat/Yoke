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
    var cusine: [Cusine] = []
    
    //MARK: - CRUD Functions
    func addCusineWith(uid: String, type: String, completion: @escaping (Bool) -> Void) {
        self.firestoreDB.collection(Constants.Cusine).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
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
        self.firestoreDB.collection(Constants.Cusine).document(uid).updateData([Constants.Cusine: FieldValue.arrayRemove([type])]) { error in
            if let error = error {
                completion(false)
                print("error in add cusine: \(error.localizedDescription)")
            } else {
                completion(true)
            }
        }
    }

        
}
