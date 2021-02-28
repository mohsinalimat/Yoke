//
//  StripeApi.swift
//  FooD
//
//  Created by LAURA JELENICH on 6/6/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions
import FirebaseFirestore
import FirebaseDatabase
import FirebaseAuth

enum Result {
  case success
  case failure(Error)
}

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
               Database.fetchUserWithUID(uid: uid) { (user) in
            Firestore.firestore().collection("stripe_customers").document(uid).addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                let document = snapshot?.data()
                let stripeId = document?["customer_id"] as! String
        
                let data = [
                    "stripe_version": apiVersion,
                    "customer_id" : stripeId
                ]
                               
                Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
                           
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        completion(nil, error)
                        return
                    }
                           
                    guard let key = result?.data as? [String: Any] else {
                        completion(nil, nil)
                        return
                    }
                           
                    completion(key, nil)
                }

                       
            })
        }
    }
    
}
