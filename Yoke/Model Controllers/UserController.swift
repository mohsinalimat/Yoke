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
    let geoRef = Firestore.firestore().collection(Constants.Users)
    
    //MARK: - Source of truth
    var user: User?
    
    //MARK: - CRUD Functions
    func createUserWith(email: String, username: String, password: String = "", image: UIImage?, location: String, isChef: Bool, completion: @escaping (Bool) -> Void) {
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
                self.firestoreDB.collection(Constants.Users).document(uid).setData([Constants.Email: email, Constants.Username: username, Constants.Uid: uid, Constants.Location: location, Constants.IsChef: isChef])
                let getUser = StripeUser.init(id: uid, customer_id: "", email: email)
                self.createFirestoreUser(stripeUser: getUser)
                completion(true)
            })
        })
    }
    
    func createUserWithProvider(uid: String, email: String, username: String, location: String, isChef: Bool, completion: @escaping (Bool) -> Void) {
        
        self.firestoreDB.collection(Constants.Users).document(uid).setData([Constants.Email: email, Constants.Username: username, Constants.Uid: uid, Constants.Location: location, Constants.IsChef: isChef]) { (error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            }
        }
        let getUser = StripeUser.init(id: uid, customer_id: "", email: email)
        self.createFirestoreUser(stripeUser: getUser)
        completion(true)
    }
    
    func createFirestoreUser(stripeUser: StripeUser) {
        let ref = Firestore.firestore().collection("stripe_customers").document(stripeUser.id)
        let data = StripeUser.modelToData(customer_id: stripeUser)
        ref.setData(data) { (error) in
            if let error = error {
//                Auth.auth().handleFirebaseErrors(error: error, vc: self)
            }
        }
    }
    
    func checkIfUserExist(uid: String, completion: @escaping (Bool) -> Void) {
        self.firestoreDB.collection(Constants.Users).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                completion(true)
            } else {
                print("Document does not exist")
                completion(false)
            }
        }
    }
    
    func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        firestoreDB.collection(Constants.Users).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dictionary = document.data() else { return }
                let uid = dictionary[Constants.Uid] as? String ?? ""
                let username = dictionary[Constants.Username] as? String ?? ""
                let location = dictionary[Constants.Location] as? String ?? ""
                let street = dictionary[Constants.Street] as? String ?? ""
                let apartment = dictionary[Constants.Apartment] as? String ?? ""
                let city = dictionary[Constants.City] as? String ?? ""
                let state = dictionary[Constants.State] as? String ?? ""
                guard let isChef = dictionary[Constants.IsChef] as? Bool else { return }
                let user = User(uid: uid, username: username, location: location, isChef: isChef, street: street, apartment: apartment, city: city, state: state)
                completion(user)
            } else {
                completion(error as! User)
                print("Document does not exist")
            }
        }
    }
//
//    func fetchUsers(userUid: String, completion: @escaping (Bool) -> Void) {
//        guard let userUid = Auth.auth().currentUser?.uid else { return }
//        firestoreDB.collection(Constants.Users).whereField("userUid", isEqualTo: userUid).getDocuments() { (snapshot, error) in
//            if (error != nil) == true {
//                print("error")
//                completion(false)
//            } else {
////                for document in snapshot!.documents {
//                    let dictionary = document.data()
//                    let userUid = dictionary["userUid"] as? String ?? ""
//                    let getNotifications = Notification(userUid: userUid, alertUid: alertUid, title: title, dateTime: dateTime)
//                    self.notifications.append(getNotifications)
//                }
//                completion(true)
//            }
//        }
//    }

    func updateUser(_ uid: String, username: String = "", bio: String = "", isChef: Bool, completion: @escaping (Bool) -> Void) {
        firestoreDB.collection(Constants.Users).document(uid).setData([Constants.Username: username, Constants.Bio: bio, Constants.IsChef: isChef], merge: true) { error in
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
    
    func setUserLocation(_ uid: String, stpod 'GeoFire', '~> 4.0'reet: String, apartment: String, city: String, state: String, latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        let geoRefData = geoRef.document(uid)
        let geoFire = GeoFire
        firestoreDB.collection(Constants.Users).document(uid).setData([Constants.Street: street, Constants.Apartment: apartment, Constants.City: city, Constants.State: state, Constants.Latitude: latitude, Constants.Longitude: longitude], merge: true) { error in
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

    func updateUserProfileImage(_ uid: String, profileImage: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let profileImage = profileImage else { return }
        guard let uploadProfileData = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = Auth.auth().currentUser?.uid ?? ""
        let storageRef = Storage.storage().reference()
        storageRef.child(Constants.ProfileImageUrl).child(filename).putData(uploadProfileData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        })
    }

    func updateUserBannerImage(_ uid: String, bannerImage: UIImage?, completion: @escaping (Bool) -> Void) {
        guard let bannerImage = bannerImage else { return }
        guard let uploadBannerData = bannerImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = Auth.auth().currentUser?.uid ?? ""
        let storageRef = Storage.storage().reference()
        storageRef.child(Constants.ProfileBannerUrl).child(filename).putData(uploadBannerData, metadata: nil, completion: { (metadata, error) in
            if let error = error {
                print("There was an error uploading image data: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        })
    }
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
