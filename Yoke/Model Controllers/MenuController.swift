//
//  MenuController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MenuController {
    
    //MARK: - Shared Instance
    static let shared = MenuController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore().collection(Constants.Chefs)
    let storageRef = Storage.storage().reference().child(Constants.MenuImage)
    
    //MARK: - Source of truth
    var menus: [Menu] = []
    
    //MARK: - CRUD Functions
    func createMenuWith(uid: String, name: String, detail: String, courseType: String, menuType: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let menuImage = image else { return }
        guard let uploadData = menuImage.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString
        let menuId = NSUUID().uuidString
        storageRef.child(filename).putData(uploadData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(false)
                return
            }
            self.storageRef.child(filename).downloadURL(completion: { (downloadURL, err) in
                guard let imageUrl = downloadURL?.absoluteString else { return }
                print("file image url\(imageUrl)")
                self.firestoreDB.document(uid).collection(Constants.Menu).document(menuId).setData([Constants.ImageUrl: imageUrl, Constants.Name: name, Constants.Detail: detail, Constants.CourseType: courseType, Constants.MenuType: menuType], merge: true)
                completion(true)
            })
        })
    }
}
