//
//  BookingController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/7/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Geofirestore
import MapKit

class BookingController {
    
    //MARK: - Shared Instance
    static let shared = BookingController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Bookings)
    let geoRef = Firestore.firestore().collection("geoFireLocationEvents")
    
    //MARK: - Source of truth
    var bookings: [Booking] = []
//    var filteredEvents = [Event]()
    
    //MARK: - Properties
    private let locationManager = LocationManager()
    
    //MARK: - CRUD Functions
    func createBookingWith(chefUid: String, completion: @escaping (Bool) -> Void) {
        let bookingId = NSUUID().uuidString
        self.firestoreDB.document(bookingId).setData([Constants.ChefUid: chefUid], merge: true)
//        self.setupGeofirestore(eventId: eventId, location: location)
        completion(true)
    }
    
    func updateBookingWith(bookingId: String, chefUid: String, completion: @escaping (Bool) -> Void) {
        self.firestoreDB.document(bookingId).setData([Constants.ChefUid: chefUid], merge: true)
//        self.setupGeofirestore(eventId: eventId, location: location)
        completion(true)
    }
    
    func setupGeofirestore(eventId: String, location: String) {
        locationManager.getLocation(forPlaceCalled: location) { location in
            guard let location = location else { return }
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let latitude = center.latitude
            let longitude = center.longitude
            let geoFirestore = GeoFirestore(collectionRef: self.geoRef)
            geoFirestore.setLocation(geopoint: GeoPoint(latitude: latitude, longitude: longitude), forDocumentWithID: eventId) { (error) in
                if let error = error {
                    print("An error occured: \(error)")
                } else {
                    print("Saved location successfully!")
                }
            }
        }

    }
    
    func fetchBookingWith(uid: String, completion: @escaping (Bool) -> Void) {
//        firestoreDB.whereField(Constants.Uid, isEqualTo: uid).addSnapshotListener { (snap, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(false)
//            } else {
//                self.events = []
//                for document in snap!.documents {
//                    let dictionary = document.data()
//                    let event = Event(dictionary: dictionary)
//                    self.events.append(event)
//                }
//                completion(true)
//            }
//        }
    }
    
    func fetchBookings(completion: @escaping (Event) -> Void) {
//        firestoreDB.addSnapshotListener { (snapshot, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                completion(error as! Event)
//            }
//            self.events = []
//            snapshot?.documents.forEach({ (document) in
//                let dictionary = document.data()
//                let event = Event(dictionary: dictionary)
//                self.events.append(event)
//                self.events.sort(by: { (u1, u2) -> Bool in
//                    return u1.timestamp.compare(u2.timestamp) == .orderedDescending
//                })
//                self.filteredEvents = self.events
//                completion(event)
//            })
//        }
    }
    
    func deleteBookingWith(eventId: String, imageId: String, completion: @escaping (Bool) -> Void) {
//        self.firestoreDB.document(eventId).delete { (error) in
//            if let error = error {
//                print("There was an error deleting the menu from deleteMenuWith in MenuController: \(error.localizedDescription)")
//                completion(false)
//                return
//            }
//            self.storageRef.child(imageId).delete { (error) in
//                if let error = error {
//                    print("error in deleting image from deleteMenuWith in MenuController: \(error.localizedDescription)")
//                }
//                completion(true)
//            }
    }
        
}
    

