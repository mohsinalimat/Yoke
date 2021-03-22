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
    let firestoreDB = Firestore.firestore().collection(Constants.Event)
    let storageRef = Storage.storage().reference().child(Constants.EventImages)
    
    //MARK: - Source of truth
    var events: [Event] = []
    
    //MARK: - CRUD Functions
    func createEventWith(uid: String, image: UIImage?, caption: String, detailText: String, date: String, time: String, location: String, completion: @escaping (Bool) -> Void) {
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
                self.firestoreDB.document(uid).collection(Constants.Event).document(eventId).setData([Constants.ImageUrl: imageUrl, Constants.Caption: caption, Constants.Detail: detailText, Constants.Date: date, Constants.Time: time, Constants.Id: eventId, Constants.Location: location, Constants.ImageId: filename, Constants.Uid: uid], merge: true)
                completion(true)
            })
        })
    }
    
    func fetchEventWith(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.document(uid).collection(Constants.Event).addSnapshotListener { (snap, error) in
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
        firestoreDB.getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(error as! Event)
            }
            self.events = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let event = Event(dictionary: dictionary)
                self.events.append(event)
                completion(event)
            })
        }
    }
    
}
