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
    let geoRef = Firestore.firestore().collection(Constants.GeoFireLocationEvents)
    
    //MARK: - Source of truth
    var bookings: [Booking] = []
    var allBookings: [Booking] = []
    var todaysBookings: [Booking] = []
    var upComingBookings: [Booking] = []
    var archives: [Booking] = []
    
    //MARK: - Properties
    private let locationManager = LocationManager()
    
    //MARK: - CRUD Functions
    func createBookingWith(chefUid: String, userUid: String, location: String, locationShort: String, date: String, startTime: String, endTime: String, numberOfPeople: Int, numberOfCourses: Int, typeOfCuisine: String, details: String, timestamp: Date, completion: @escaping (Bool) -> Void) {
        let bookingId = NSUUID().uuidString
        self.firestoreDB.document(chefUid).collection(Constants.Bookings).document(bookingId).setData([Constants.ChefUid: chefUid, Constants.Id: bookingId, Constants.UserUid: userUid, Constants.Location: location, Constants.LocationShort: locationShort, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.NumberOfPeople: numberOfPeople, Constants.NumberOfCourses: numberOfCourses, Constants.Detail: details, Constants.IsBooked: false, Constants.CuisineType: typeOfCuisine, Constants.Timestamp: timestamp], merge: true)
        self.firestoreDB.document(userUid).collection(Constants.Bookings).document(bookingId).setData([Constants.ChefUid: chefUid, Constants.Id: bookingId, Constants.UserUid: userUid, Constants.Location: location, Constants.LocationShort: locationShort, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.NumberOfPeople: numberOfPeople, Constants.NumberOfCourses: numberOfCourses, Constants.Detail: details, Constants.IsBooked: false, Constants.CuisineType: typeOfCuisine, Constants.Timestamp: timestamp], merge: true)
        completion(true)
    }
    
    func updateBookingWith(bookingId: String, chefUid: String, location: String, date: String, startTime: String, endTime: String, numberOfPeople: Int, numberOfCourses: Int, typeOfCuisine: String, details: String, completion: @escaping (Bool) -> Void) {
        self.firestoreDB.document(bookingId).setData([Constants.Location: location, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.NumberOfPeople: numberOfPeople, Constants.NumberOfCourses: numberOfCourses, Constants.Detail: details, ], merge: true)
        completion(true)
    }
    
    func updateBookingPaymentRequestWith(bookingId: String, chefUid: String, userUid: String, isBooked: Bool, invoiceSent: Bool, notes: String, total: String, completion: @escaping (Bool) -> Void) {
        self.firestoreDB.document(chefUid).collection(Constants.Bookings).document(bookingId).setData([Constants.IsBooked: isBooked, Constants.InvoiceSent: invoiceSent, Constants.Note: notes, Constants.Total: total], merge: true) { error in
            if let error = error {
                print("There was an error updating data: \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
                print("Document successfully updated")
            }
        }
        self.firestoreDB.document(userUid).collection(Constants.Bookings).document(bookingId).setData([Constants.IsBooked: isBooked, Constants.InvoiceSent: invoiceSent, Constants.Note: notes, Constants.Total: total], merge: true) { error in
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
    
    func fetchAllBookingsWith(uid: String, completion: @escaping (Bool) -> Void) {
        let currentDate = Calendar.current.startOfDay(for: Date())
        
        firestoreDB.document(uid).collection(Constants.Bookings).whereField(Constants.Timestamp, isGreaterThanOrEqualTo: currentDate).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.allBookings = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let booking = Booking(dictionary: dictionary)
                self.allBookings.append(booking)
                self.allBookings.sort(by: { (u1, u2) -> Bool in
                    guard let date1 = u1.date,
                          let date2 = u2.date else { return false }
                    return date1.compare(date2) == .orderedAscending
                })
                completion(true)
            })
        }
    }
    
    func fetchBookingsWith(uid: String, completion: @escaping (Bool) -> Void) {
        let currentDate = Calendar.current.startOfDay(for: Date())
        firestoreDB.document(uid).collection(Constants.Bookings).whereField(Constants.Timestamp, isGreaterThanOrEqualTo: currentDate).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.bookings = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let isBooked = dictionary[Constants.IsBooked] as? Bool
                if isBooked == true {
                    let booking = Booking(dictionary: dictionary)
                    self.bookings.append(booking)
                    self.bookings.sort(by: { (u1, u2) -> Bool in
                        guard let date1 = u1.date,
                              let date2 = u2.date else { return false }
                        return date1.compare(date2) == .orderedAscending
                    })
                    completion(true)
                }
            })
        }
    }
    
    func fetchTodaysBookingsWith(uid: String, completion: @escaping (Bool) -> Void) {
        let currentDate = Calendar.current.startOfDay(for: Date())
        firestoreDB.document(uid).collection(Constants.Bookings).whereField(Constants.Timestamp, isEqualTo: currentDate).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.todaysBookings = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                print("dict \(dictionary)")
                let isBooked = dictionary[Constants.IsBooked] as? Bool
                if isBooked == true {
                    let booking = Booking(dictionary: dictionary)
                    self.todaysBookings.append(booking)
                    self.todaysBookings.sort(by: { (u1, u2) -> Bool in
                        guard let date1 = u1.date,
                              let date2 = u2.date else { return false }
                        return date1.compare(date2) == .orderedAscending
                    })
                    completion(true)
                }
            })
        }
    }
    
    func fetchUpcomingBookingsWith(uid: String, completion: @escaping (Bool) -> Void) {
        let currentDate = Calendar.current.startOfDay(for: Date())
        firestoreDB.document(uid).collection(Constants.Bookings).whereField(Constants.Timestamp, isGreaterThanOrEqualTo: currentDate).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.upComingBookings = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                print("dict \(dictionary)")
                let isBooked = dictionary[Constants.IsBooked] as? Bool
                if isBooked == true {
                    let booking = Booking(dictionary: dictionary)
                    self.upComingBookings.append(booking)
                    self.upComingBookings.sort(by: { (u1, u2) -> Bool in
                        guard let date1 = u1.date,
                              let date2 = u2.date else { return false }
                        return date1.compare(date2) == .orderedAscending
                    })
                    completion(true)
                }
            })
        }
    }
    
    
    func fetchArchivesWith(uid: String, completion: @escaping (Bool) -> Void) {
        let currentDate = Calendar.current.startOfDay(for: Date())
        firestoreDB.document(uid).collection(Constants.Bookings).whereField(Constants.Timestamp, isLessThan: currentDate).addSnapshotListener { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
            self.archives = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let isBooked = dictionary[Constants.IsBooked] as? Bool
                if isBooked == true {
                    let booking = Booking(dictionary: dictionary)
                    self.archives.append(booking)
                    self.archives.sort(by: { (u1, u2) -> Bool in
                        guard let date1 = u1.date,
                              let date2 = u2.date else { return false }
                        return date1.compare(date2) == .orderedAscending
                    })
                    completion(true)
                }
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
    

