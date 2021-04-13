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
    let firestoreDB = Firestore.firestore().collection(Constants.Users)
    let geoRef = Firestore.firestore().collection("geoFireLocationEvents")
    
    //MARK: - Source of truth
    var bookings: [Booking] = []
//    var filteredEvents = [Event]()
    
    //MARK: - Properties
    private let locationManager = LocationManager()
    
    //MARK: - CRUD Functions
    func createBookingWith(chefUid: String, userUid: String, location: String, date: String, startTime: String, endTime: String, numberOfPeople: Int, numberOfCourses: Int, typeOfCuisine: String, details: String, completion: @escaping (Bool) -> Void) {
        let bookingId = NSUUID().uuidString
        self.firestoreDB.document(chefUid).collection(Constants.Bookings).document(bookingId).setData([Constants.ChefUid: chefUid, Constants.Id: bookingId, Constants.UserUid: userUid, Constants.Location: location, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.NumberOfPeople: numberOfPeople, Constants.NumberOfCourses: numberOfCourses, Constants.Detail: details, Constants.InvoiceSent: false, Constants.InvoicePaid: false, Constants.IsBooked: false], merge: true)
        self.firestoreDB.document(userUid).collection(Constants.Bookings).document(bookingId).setData([Constants.ChefUid: chefUid, Constants.Id: bookingId, Constants.UserUid: userUid, Constants.Location: location, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.NumberOfPeople: numberOfPeople, Constants.NumberOfCourses: numberOfCourses, Constants.Detail: details, Constants.InvoiceSent: false, Constants.InvoicePaid: false, Constants.IsBooked: false], merge: true)
//        self.firestoreDB.document(bookingId).setData([Constants.ChefUid: chefUid, Constants.Id: bookingId, Constants.UserUid: userUid, Constants.Location: location, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.NumberOfPeople: numberOfPeople, Constants.NumberOfCourses: numberOfCourses, Constants.Detail: details, Constants.InvoiceSent: false, Constants.InvoicePaid: false, Constants.IsBooked: false], merge: true)
//        self.setupGeofirestore(eventId: eventId, location: location)
        completion(true)
    }
    
    func updateBookingWith(bookingId: String, chefUid: String, location: String, date: String, startTime: String, endTime: String, numberOfPeople: Int, numberOfCourses: Int, typeOfCuisine: String, details: String, completion: @escaping (Bool) -> Void) {
        self.firestoreDB.document(bookingId).setData([Constants.Location: location, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.NumberOfPeople: numberOfPeople, Constants.NumberOfCourses: numberOfCourses, Constants.Detail: details], merge: true)
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
        firestoreDB.document(uid).collection(Constants.Bookings).addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                self.bookings = []
                for document in snap!.documents {
                    let dictionary = document.data()
                    let booking = Booking(dictionary: dictionary)
                    self.bookings.append(booking)
                }
                completion(true)
            }
        }
    }
    
    func fetchBookingsWith(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.Bookings).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.bookings = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let booking = Booking(dictionary: dictionary)
                self.bookings.append(booking)
                self.bookings.sort(by: { (u1, u2) -> Bool in
                    return u1.timestamp.compare(u2.timestamp) == .orderedDescending
                })
                completion(true)
            })
        }
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
    

