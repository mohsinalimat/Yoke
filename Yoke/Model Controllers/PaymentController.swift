//
//  PaymentController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum UserError: LocalizedError {
    case fbUserError(Error)
    case unwrapError
    
    var errorDescription: String {
        switch self {
        case .fbUserError(let error):
            return "There was an error: \(error.localizedDescription)"
        case .unwrapError:
            return "Unable to unwrap this user."
        }
    }
}

class PaymentController {
    //MARK: - Shared Instance
    static let shared = PaymentController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Users)
    
    //MARK: - Source of truth
    var payments: [Payment] = []
    
    //MARK: - CRUD Functions
    func createPaymentWith(bookingId: String, chefUid: String, userUid: String, amount: Double, fees: Double, total: Double, reference: String, description: String, paid: Bool, completion: @escaping (Bool) -> Void) {
        
        let paymentId = NSUUID().uuidString
        firestoreDB.document(chefUid).collection(Constants.Payments).document(paymentId).setData([Constants.BookingId: bookingId, Constants.ChefUid: chefUid, Constants.UserUid: userUid, Constants.Amount: amount, Constants.Fees: fees, Constants.Total: total, Constants.InvoicePaid: paid], merge: true) { error in
            if let error = error {
                print("There was an error updating data: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                print("Document successfully updated")
            }
        }
        firestoreDB.document(userUid).collection(Constants.Payments).document(paymentId).setData([Constants.BookingId: bookingId, Constants.ChefUid: chefUid, Constants.UserUid: userUid, Constants.Amount: amount, Constants.Fees: fees, Constants.Total: total, Constants.InvoicePaid: paid], merge: true) { error in
            if let error = error {
                print("There was an error updating data: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                print("Document successfully updated")
            }
        }
    }
}
