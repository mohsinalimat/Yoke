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
    func createImageWith(image: UIImage?, uid: String, caption: String, location: String, timestamp: String, completion: @escaping (Bool) -> Void) {
        guard let sharedImage = image else { return }
        guard let uploadData = sharedImage.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        let imageId = NSUUID().uuidString
        storageRef.child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(false)
                return
            }
            self.storageRef.child(filename).downloadURL(completion: { (downloadURL, err) in
                guard let imageUrl = downloadURL?.absoluteString else { return }
                print("file image url\(imageUrl)")
                self.firestoreDB.document(uid).collection(Constants.SharedPhotos).document(imageId).setData([Constants.ImageUrl: imageUrl, Constants.Caption: caption, Constants.Timestamp: timestamp, Constants.Location: location, Constants.Id: imageId], merge: true)
                completion(true)
            })
        })
    }
    
    func fetchGalleryWith(uid: String, completion: @escaping (Bool) -> ()) {
        firestoreDB.whereField(Constants.Uid, isEqualTo: uid).getDocuments() { (snapshot, error) in
            if (error != nil) == true {
                print("error")
                completion(false)
            } else {
                for document in snapshot!.documents {
                    let dictionary = document.data()
                    print("fetchGallery: \(dictionary)")
                    guard let imageUrl = dictionary[Constants.ImageUrl] as? String,
                          let caption = dictionary[Constants.Caption] as? String,
                          let location = dictionary[Constants.Location] as? String,
                          let timestamp = dictionary[Constants.Timestamp] as? String else { return }
                    let gallery = Gallery(uid: uid, imageUrl: imageUrl, caption: caption, location: location, likeCount: 0, isLiked: false, timestamp: timestamp)
                    self.galleries.insert(gallery, at: 0)
//                    self.galleries.append(gallery)
//                    completion(true)
                }
                completion(true)
            }
        }
    }
    
    
}
