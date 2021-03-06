//
//  EventController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/22/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Geofirestore
import MapKit

class EventController {
    
    //MARK: - Shared Instance
    static let shared = EventController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Events)
    let geoRef = Firestore.firestore().collection(Constants.GeoFireLocationEvents)
    let storageRef = Storage.storage().reference().child(Constants.EventImages)
    
    
    //MARK: - Source of truth
    var events: [Event] = []
    var filteredEvents = [Event]()
    
    //MARK: - Properties
    private let locationManager = LocationManager()
    
    //MARK: - CRUD Functions
    func createEventWith(uid: String, image: UIImage?, caption: String, detailText: String, date: String, startTime: String, endTime: String, location: String, shortLocation: String, allowsRSVP: Bool, allowsContact: Bool, completion: @escaping (Bool) -> Void) {
        let eventId = NSUUID().uuidString
        if image == nil {
            self.firestoreDB.document(eventId).setData([Constants.EventImageUrl: "", Constants.Caption: caption, Constants.Detail: detailText, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.Id: eventId, Constants.Location: location, Constants.ShortLocation: shortLocation, Constants.ImageId: "", Constants.Uid: uid, Constants.Timestamp: Date().timeIntervalSince1970, Constants.AllowsRSVP: allowsRSVP, Constants.AllowsContact: allowsContact], merge: true)
            self.setupGeofirestore(eventId: eventId, location: location)
            completion(true)
        } else {
            guard let eventImage = image else { return }
            guard let uploadData = eventImage.jpegData(compressionQuality: 0.5) else {return}
            let filename = NSUUID().uuidString
        
            storageRef.child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if let error = error {
                    print("There was an error uploading image data: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                self.storageRef.child(filename).downloadURL(completion: { (downloadURL, err) in
                    guard let imageUrl = downloadURL?.absoluteString else { return }
                    self.firestoreDB.document(eventId).setData([Constants.EventImageUrl: imageUrl, Constants.Caption: caption, Constants.Detail: detailText, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.Id: eventId, Constants.Location: location, Constants.ShortLocation: shortLocation, Constants.ImageId: filename, Constants.Uid: uid, Constants.Timestamp: Date().timeIntervalSince1970, Constants.AllowsRSVP: allowsRSVP, Constants.AllowsContact: allowsContact], merge: true)
                    self.setupGeofirestore(eventId: eventId, location: location)
                    completion(true)
                })
            })
        }
    }
    
    func updateEventWith(uid: String, eventId: String, image: UIImage?, caption: String, detailText: String, date: String, startTime: String, endTime: String, location: String, shortLocation: String, allowsRSVP: Bool, allowsContact: Bool, completion: @escaping (Bool) -> Void) {
        guard let eventImage = image else { return }
        guard let uploadData = eventImage.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        storageRef.child(eventId).delete { (error) in
            if let error = error {
                print("error in deleting image from updateMenuWith in MenuController: \(error.localizedDescription)")
            }
        }
        storageRef.child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(false)
                return
            }
            self.storageRef.child(filename).downloadURL(completion: { (downloadURL, err) in
                guard let imageUrl = downloadURL?.absoluteString else { return }
                self.firestoreDB.document(eventId).setData([Constants.EventImageUrl: imageUrl, Constants.Caption: caption, Constants.Detail: detailText, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.Id: eventId, Constants.Location: location, Constants.ShortLocation: shortLocation, Constants.ImageId: filename, Constants.Uid: uid, Constants.AllowsRSVP: allowsRSVP, Constants.AllowsContact: allowsContact], merge: true)
                self.setupGeofirestore(eventId: eventId, location: location)
                completion(true)
            })
        })
    }
    
    func setupGeofirestore(eventId: String, location: String) {
        self.locationManager.getLocation(forPlaceCalled: location) { location in
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
    
    func fetchEventWith(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.whereField(Constants.Uid, isEqualTo: uid).addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                self.events = []
                for document in snap!.documents {
                    let dictionary = document.data()
                    let event = Event(dictionary: dictionary)
                    self.events.append(event)
                }
                completion(true)
            }
        }
    }
    
    func fetchEvents(completion: @escaping (Event) -> Void) {
        firestoreDB.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            self.events = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let event = Event(dictionary: dictionary)
                self.events.append(event)
                self.events.sort(by: { (u1, u2) -> Bool in
                    return u1.timestamp.compare(u2.timestamp) == .orderedDescending
                })
                self.filteredEvents = self.events
                completion(event)
            })
        }
    }
    
    func fetchSuggestedEventsWith(latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        
        let currentLatitude = latitude
        let currentLongitude = longitude
        
        let circleQuery = GeoFirestore(collectionRef: self.geoRef).query(withCenter: GeoPoint(latitude: currentLatitude, longitude: currentLongitude), radius: 20.0)
        let _ = circleQuery.observeReady {
            print("All initial data has been loaded and events have been fired!")
        }
        let _ = circleQuery.observe(.documentEntered, with: { (key, location) in
            guard let key = key else { return }
            self.firestoreDB.addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                }
                snapshot?.documents.forEach({ (document) in
                    let dictionary = document.data()
                    let eventId = dictionary[Constants.Id] as? String ?? ""
                    if eventId == key {
                        let event = Event(dictionary: dictionary)
                        self.events.append(event)
                        self.events.sort(by: { (u1, u2) -> Bool in
                            return u1.timestamp.compare(u2.timestamp) == .orderedDescending
                        })
                        completion(true)
                    }
                })
            }
        })
    }
    
    func deleteEventWith(eventId: String, imageId: String, completion: @escaping (Bool) -> Void) {
        self.firestoreDB.document(eventId).delete { (error) in
            if let error = error {
                print("There was an error deleting the menu from deleteMenuWith in MenuController: \(error.localizedDescription)")
                completion(false)
                return
            }
            self.storageRef.child(imageId).delete { (error) in
                if let error = error {
                    print("error in deleting image from deleteMenuWith in MenuController: \(error.localizedDescription)")
                }
                completion(true)
            }
        }
    }
}
