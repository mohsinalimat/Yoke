//
//  StripeController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/20/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import FirebaseFirestore

class StripeController {
    
    //MARK: - Shared Instance
    static let shared = StripeController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection("stripe_customers")
    
    //MARK: - CRUD Functions
    
}
