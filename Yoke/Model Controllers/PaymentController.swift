//
//  PaymentController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import FirebaseFirestore

class PaymentController {
    //MARK: - Shared Instance
    static let shared = PaymentController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Users)
    
    //MARK: - Source of truth
    var payments: [Payment] = []
    
    //MARK: - CRUD Functions
    func createPaymentWith(bookingId: String, chefUid: String, userUid: String, amount: Double, fees: Double, total: Double, reference: String, text: String, paid: Bool, completion: @escaping (Bool) -> Void) {
        
        let paymentId = NSUUID().uuidString
        firestoreDB.document(chefUid).collection(Constants.Payments).document(paymentId).setData([Constants.BookingId: bookingId, Constants.ChefUid: chefUid, Constants.UserUid: userUid, Constants.Amount: amount, Constants.Fees: fees, Constants.Total: total, Constants.InvoicePaid: paid, Constants.Text: text, Constants.Reference: reference], merge: true) { error in
            if let error = error {
                print("There was an error updating data: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                print("Document successfully updated")
            }
        }
        firestoreDB.document(userUid).collection(Constants.Payments).document(paymentId).setData([Constants.BookingId: bookingId, Constants.ChefUid: chefUid, Constants.UserUid: userUid, Constants.Amount: amount, Constants.Fees: fees, Constants.Total: total, Constants.InvoicePaid: paid, Constants.Text: text, Constants.Reference: reference], merge: true) { error in
            if let error = error {
                print("There was an error updating data: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                print("Document successfully updated")
            }
        }
        BookingController.shared.updateBookingPaymentRequestWith(paymentId: paymentId, bookingId: bookingId, chefUid: chefUid, userUid: userUid, isBooked: false, invoiceSent: true, invoicePaid: false, archive: false) { result in
            switch result {
            case true:
                print("update success")
            case false:
                print("update failed")
            }
        }
    }
    
    func fetchPaymentWith(uid: String, paymentId: String, completion: @escaping (Payment) -> Void) {
        firestoreDB.document(uid).collection(Constants.Payments).document(paymentId).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dictionary = document.data() else { return }
                let payment = Payment(dictionary: dictionary)
                completion(payment)
            } else {
                completion(error as! Payment)
                print("Document does not exist")
            }
        }
    }
}
