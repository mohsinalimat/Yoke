//
//  ReviewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/18/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ReviewController {
    
    //MARK: - Properties
    var todayDateAndHourString = ""
    
    //MARK: - Shared Instance
    static let shared = ReviewController()

    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Users)

    //MARK: - Source of truth
    var reviews: [Review] = []
    var average: Double = 0.0

    //MARK: - CRUD Functions
    func getTodaysDate() {
        let todayDateAndHour = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        todayDateAndHourString = dateFormatter.string(from: todayDateAndHour)
    }
    
    func createReviewWith(currentUserUid: String, reviewedUserUid: String, review: String, liveRate: Double, username: String, completion: @escaping (Bool) -> ()) {
        
        let rateValues = [Constants.Stars: liveRate]
        
        let key = NSUUID().uuidString
        let values = [Constants.Review: review, Constants.Timestamp: todayDateAndHourString, Constants.Uid: currentUserUid, Constants.ReviewedUserUid: reviewedUserUid, Constants.Ratings: liveRate, Constants.Key: key, Constants.Username: username] as [String : Any]
        
        firestoreDB.document(reviewedUserUid).collection(Constants.Reviews).document(key).setData(values) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            completion(true)
        }
        
        firestoreDB.document(reviewedUserUid).collection(Constants.Ratings).document(key).setData(rateValues) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            completion(true)
        }
    }
    
    func fetchReviewsFor(uid: String, completion: @escaping (Bool) -> ()) {
        firestoreDB.document(uid).collection(Constants.Reviews).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.reviews = []
            for document in snapshot!.documents {
                let dictionary = document.data()
                if uid != Constants.ReviewedUserUid {
                    let review = Review(dictionary: dictionary)
                    self.reviews.append(review)
                    completion(true)
                }
            }
        }
    }
}
