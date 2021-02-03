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

class SuggestedChefController {
    //MARK: - Shared Instance
    static let shared = SuggestedChefController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Users)
    let geoRef = Firestore.firestore().collection("geoFireLocation")
    
    //MARK: - Source of truth
    var chefs: [User] = []
    
    //MARK: - CRUD Functions
    func fetchSuggestedChefsWith(latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        
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
                    if user.isChef == true {
                        print("chefs \(user.username)")
                        self.chefs.append(user)
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        })
    }
    
    func getChefs(latitude: Double, longitude: Double) {
            let currentLatitude = latitude
            let currentLongitude = longitude

        let circleQuery = GeoFirestore(collectionRef: self.geoRef).query(withCenter: GeoPoint(latitude: currentLatitude, longitude: currentLongitude), radius: 20.0)
            let _ = circleQuery.observeReady {
                print("All initial data has been loaded and events have been fired!")
            }
            let _ = circleQuery.observe(.documentEntered, with: { (key, location) in
                if let key = key {
                    UserController.shared.fetchUserWithUID(uid: key) { (user) in
                        if user.isChef == true {
                            UserController.shared.users.append(user)
                        }
                    }
                }
//                self.geoRef.getDocuments { (querySnapshot, error) in
//                    if let error = error {
//                        print(error.localizedDescription)
//                    } else {
//                        for document in querySnapshot!.documents {
//                            let uid = document.documentID
//                            UserController.shared.fetchUserWithUID(uid: uid) { (user) in
//                                print(user.username)
//                            }
//                            print("\(document.documentID) => \(document.data())")
//                        }
//                    }
//                }
//                self.geoRef.document(key!).getDocument { (document, error) in
//                    print("doc data \(key)")
//                    if let document = document, document.exists {
//                        guard let getDoc = document.data() else { return }
//                        for x in getDoc {
//                            print("this is x \(x)")
//                        }
////                        print("Query Data: \(document.data())")
////                        UserController.shared.users.append(document.data())
////                        self.addFaciltiesToMap()
//                    } else {
//                        print("Document does not exist.")
//                    }
//                }
            })
        }
    
    func getDocumentNearBy(latitude: Double, longitude: Double, distance: Double) {
        // ~1 mile of lat and lon in degrees
        let lat = 0.0144927536231884
        let lon = 0.0181818181818182

        let lowerLat = latitude - (lat * distance)
        let lowerLon = longitude - (lon * distance)

        let greaterLat = latitude + (lat * distance)
        let greaterLon = longitude + (lon * distance)

        let lesserGeopoint = GeoPoint(latitude: lowerLat, longitude: lowerLon)
        let greaterGeopoint = GeoPoint(latitude: greaterLat, longitude: greaterLon)

        let docRef = Firestore.firestore().collection("locations")
        let query = docRef.whereField("location", isGreaterThan: lesserGeopoint).whereField("location", isLessThan: greaterGeopoint)

        query.getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }

    }

    func run() {
        // Get all locations within 10 miles of Google Headquarters
        getDocumentNearBy(latitude: 37.422000, longitude: -122.084057, distance: 10)
    }
    
    
}