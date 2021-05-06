//
//  StripeController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 5/6/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import FirebaseFirestore

class StripeController {
    //MARK: - Shared Instance
    static let shared = StripeController()
    
    //MARK: - Firebase Firestore Database
    let firestoreStripeAccountDB = Firestore.firestore().collection(Constants.StripeAccounts)
    
    
    //MARK: - CRUD Functions
    
}
