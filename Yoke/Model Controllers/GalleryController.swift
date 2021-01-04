//
//  GalleryController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 12/24/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class GalleryController {
    //MARK: - Shared Instance
    static let shared = GalleryController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Gallery)
    let storageRef = Storage.storage().reference().child(Constants.SharedPhotos)
    
    //MARK: - Source of truth
    var gallery: Gallery?
    var galleries: [Gallery] = []
    
    //MARK: - CRUD Functions
    func createPostWith(image: UIImage?, uid: String, caption: String, location: String, timestamp: String, completion: @escaping (Bool) -> Void) {
        guard let sharedImage = image else { return }
        guard let uploadData = sharedImage.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        storageRef.child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print(err)
                return
            }
            self.storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to retrieve downloadURL:", err)
                    completion(false)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image:", imageUrl)
                self.firestoreDB.document(uid).setData([Constants.ImageUrl: imageUrl, Constants.Caption: caption, Constants.Timestamp: timestamp, Constants.Location: location])
                completion(true)
            })
        }
    }
    
    func fetchGalleryWith(user: User, completion: @escaping (Bool) -> ()) {
        firestoreDB.whereField(Constants.Uid, isEqualTo: user.uid).getDocuments() { (snapshot, error) in
            if (error != nil) == true {
                print("error")
                completion(false)
            } else {
                for document in snapshot!.documents {
                    let dictionary = document.data()
                    guard let imageUrl = dictionary[Constants.ImageUrl] as? String,
                          let caption = dictionary[Constants.Caption] as? String,
                          let location = dictionary[Constants.Location] as? String,
                          let timestamp = dictionary[Constants.Timestamp] as? String else { return }
                    let gallery = Gallery(user: user, imageUrl: imageUrl, caption: caption, location: location, likeCount: 0, isLiked: false, timestamp: timestamp)
                    self.galleries.insert(gallery, at: 0)
                }
            }
        }
    }
    
    
}
