//
//  UserController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 12/9/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserController {
    
    //MARK: - Shared Instance
    static let shared = UserController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore()
    
    //MARK: - Source of truth
    var user: User?
    
    //MARK: - CRUD Functions
    func createUser(email: String, username: String, password: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("There was an error authorizing user: \(error.localizedDescription)")
                completion(false)
            }

            guard let image = image else { return }
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }

            let filename = Auth.auth().currentUser?.uid ?? ""

            let storageRef = Storage.storage().reference().child(Constants.ProfileImageUrl).child(filename)
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

                if let error = error {
                    print("There was an error uploading image data: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                guard let uid = user?.user.uid else { return }
                self.firestoreDB.collection(Constants.Users).document(uid).setData([Constants.Email: email, Constants.Username: username, Constants.Uid: uid])
                let getUser = StripeUser.init(id: uid, customer_id: "", email: email)
                self.createFirestoreUser(stripeUser: getUser)
                completion(true)
//                storageRef.downloadURL(completion: { (downloadURL, err) in
//                    guard let uid = user?.user.uid, let imageUrl = downloadURL else { return }
//                    self.firestoreDB.collection(Constants.Users).document(uid).setData([Constants.Email: email, Constants.Username: username, Constants.Uid: uid])
//                    let getUser = StripeUser.init(id: uid, customer_id: "", email: email)
//                    self.createFirestoreUser(stripeUser: getUser)
////                    completion(.success(true))
//                })
            })
        })
    }
//    func createUser(email: String, username: String, password: String, image: UIImage?, completion: @escaping (Result<Bool, UserError>) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
//            if let error = error {
//                print("There was an error authorizing user: \(error.localizedDescription)")
//                completion(.failure(.fbUserError(error)))
//            }
//
//            guard let image = image else { return }
//            guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
//
//            let filename = Auth.auth().currentUser?.uid ?? ""
//
//            let storageRef = Storage.storage().reference().child(Constants.ProfileImageUrl).child(filename)
//            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//
//                if let error = error {
//                    print("There was an error uploading image data: \(error.localizedDescription)")
//                    completion(.failure(.fbUserError(error)))
//                    return
//                }
//
//                storageRef.downloadURL(completion: { (downloadURL, err) in
//                    guard let uid = user?.user.uid else { return }
//                    self.firestoreDB.collection(Constants.users).document(uid).setData([Constants.email: email, Constants.username: username, Constants.uid: uid, Constants.location: "", Constants.bio: "", Constants.bannerImageUrl: ""])
//                    let getUser = StripeUser.init(id: uid, customer_id: "", email: email)
//                    self.createFirestoreUser(stripeUser: getUser)
//                    completion(.success(true))
//                })
//            })
//        })
//    }
    
    func createFirestoreUser(stripeUser: StripeUser) {
        let ref = Firestore.firestore().collection("stripe_customers").document(stripeUser.id)
        let data = StripeUser.modelToData(customer_id: stripeUser)
        ref.setData(data) { (error) in
            if let error = error {
//                Auth.auth().handleFirebaseErrors(error: error, vc: self)
            }
        }
    }
    
//    func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
//        firestoreDB.collection(Constants.Users).document(uid).getDocument { (document, error) in
//            if let document = document, document.exists {
//                guard let dictionary = document.data() else { return }
//                guard let username = dictionary[Constants.Username] as? String,
//                      let location = dictionary[Constants.Location] as? String else { return }
//                let user = User(username: username, location: location, bio: bio)
//                completion(user)
//            } else {
//                completion(error as! User)
//                print("Document does not exist")
//            }
//        }
//    }
//
//    func fetchUsers(userUid: String, completion: @escaping (Bool) -> Void) {
//        guard let userUid = Auth.auth().currentUser?.uid else { return }
//        firestoreDB.collection(Constants.Users).whereField("userUid", isEqualTo: userUid).getDocuments() { (snapshot, error) in
//            if (error != nil) == true {
//                print("error")
//                completion(false)
//            } else {
////                for document in snapshot!.documents {
////                    let dictionary = document.data()
////                    let userUid = dictionary["userUid"] as? String ?? ""
////                    let getNotifications = Notification(userUid: userUid, alertUid: alertUid, title: title, dateTime: dateTime)
////                    self.notifications.append(getNotifications)
////                }
//                completion(true)
//            }
//        }
//    }
//
//    func updateUser(_ uid: String, username: String, location: String, bio: String, completion: @escaping (Result<User?, UserError>) -> Void) {
//        firestoreDB.collection(Constants.users).document(uid).setData([Constants.username: username, Constants.location: location, Constants.bio: bio], merge: true) { error in
//            if let error = error {
//                print("There was an error updating data: \(error.localizedDescription)")
//                completion(.failure(.fbUserError(error)))
//                return
//            } else {
//                completion(.success(self.user))
//                print("Document successfully updated")
//            }
//        }
//    }
//
//    func updateUserProfileImage(_ uid: String, profileImage: UIImage?, completion: @escaping (Result<Bool, UserError>) -> Void) {
//        guard let profileImage = profileImage else { return }
//        guard let uploadProfileData = profileImage.jpegData(compressionQuality: 0.3) else { return }
//        let filename = Auth.auth().currentUser?.uid ?? ""
//        let storageRef = Storage.storage().reference()
//        storageRef.child(Constants.profileImage).child(filename).putData(uploadProfileData, metadata: nil, completion: { (metadata, error) in
//            if let error = error {
//                print("There was an error uploading image data: \(error.localizedDescription)")
//                completion(.failure(.fbUserError(error)))
//                return
//            }
//            completion(.success(true))
//        })
//    }
//
//    func updateUserBannerImage(_ uid: String, bannerImage: UIImage?, completion: @escaping (Result<Bool, UserError>) -> Void) {
//        guard let bannerImage = bannerImage else { return }
//        guard let uploadBannerData = bannerImage.jpegData(compressionQuality: 0.3) else { return }
//        let filename = Auth.auth().currentUser?.uid ?? ""
//        let storageRef = Storage.storage().reference()
//        storageRef.child(Constants.bannerImage).child(filename).putData(uploadBannerData, metadata: nil, completion: { (metadata, error) in
//            if let error = error {
//                print("There was an error uploading image data: \(error.localizedDescription)")
//                completion(.failure(.fbUserError(error)))
//                return
//            }
//            completion(.success(true))
//        })
//    }
//
//    func deleteUserData(_ uid: String, completion: @escaping (Result<Bool, UserError>) -> Void) {
//        firestoreDB.collection(Constants.users).document(uid).delete() { error in
//            if let error = error {
//                print("There was an error deleting user: \(error.localizedDescription)")
//                completion(.failure(.fbUserError(error)))
//            } else {
//                completion(.success(true))
//            }
//        }
//    }
}
