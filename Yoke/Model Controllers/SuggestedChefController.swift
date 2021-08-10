//
//  SuggestedChefController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import Foundation
import Firebase
import Geofirestore
import FirebaseFirestore

class SuggestedChefController {
    
    //MARK: - Shared Instance
    static let shared = SuggestedChefController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Users)
    let geoRef = Firestore.firestore().collection(Constants.GeoFireLocation)
    
    //MARK: - Source of truth
    var chefs: [User] = []
    
    //MARK: - CRUD Functions
    func fetchSuggestedChefsWith(uid: String, latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        
        let currentLatitude = latitude
        let currentLongitude = longitude
        
        let circleQuery = GeoFirestore(collectionRef: self.geoRef).query(withCenter: GeoPoint(latitude: currentLatitude, longitude: currentLongitude), radius: 80.0)
        let _ = circleQuery.observeReady {
            print("All initial data has been loaded and events have been fired!")
        }
        
        let _ = circleQuery.observe(.documentEntered, with: { (key, location) in
            if let key = key {
                print(key)
                UserController.shared.fetchUserWithUID(uid: key) { (user) in
                    if user.isChef == true && key != uid {
                        self.chefs.append(user)
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        })
    }
}
