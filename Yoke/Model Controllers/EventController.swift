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

class EventController {
    
    //MARK: - Shared Instance
    static let shared = EventController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Events)
    let storageRef = Storage.storage().reference().child(Constants.EventImages)
    
    //MARK: - Source of truth
    var events: [Event] = []
    var filteredEvents = [Event]()
    
    //MARK: - CRUD Functions
    func createEventWith(uid: String, image: UIImage?, caption: String, detailText: String, date: String, startTime: String, endTime: String, location: String, allowsRSVP: Bool, allowsContact: Bool, completion: @escaping (Bool) -> Void) {
        guard let eventImage = image else { return }
        guard let uploadData = eventImage.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        let eventId = NSUUID().uuidString
        storageRef.child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(false)
                return
            }
            self.storageRef.child(filename).downloadURL(completion: { (downloadURL, err) in
                guard let imageUrl = downloadURL?.absoluteString else { return }
                self.firestoreDB.document(eventId).setData([Constants.EventImageUrl: imageUrl, Constants.Caption: caption, Constants.Detail: detailText, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.Id: eventId, Constants.Location: location, Constants.ImageId: filename, Constants.Uid: uid, Constants.Timestamp: Date().timeIntervalSince1970, Constants.AllowsRSVP: allowsRSVP, Constants.AllowsContact: allowsContact], merge: true)
                completion(true)
            })
        })
    }
    
    func updateEventWith(uid: String, eventId: String, image: UIImage?, caption: String, detailText: String, date: String, startTime: String, endTime: String, location: String, allowsRSVP: Bool, allowsContact: Bool, completion: @escaping (Bool) -> Void) {
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
                self.firestoreDB.document(uid).collection(Constants.Menu).document(eventId).setData([Constants.EventImageUrl: imageUrl, Constants.Caption: caption, Constants.Detail: detailText, Constants.Date: date, Constants.StartTime: startTime, Constants.EndTime: endTime, Constants.Id: eventId, Constants.Location: location, Constants.ImageId: filename, Constants.Uid: uid, Constants.AllowsRSVP: allowsRSVP, Constants.AllowsContact: allowsContact], merge: true)
                completion(true)
            })
        })
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
                completion(error as! Event)
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
    
}
