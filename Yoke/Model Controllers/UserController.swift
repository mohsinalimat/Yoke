//
//  UserController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 12/9/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Geofirestore
import MapKit

//https://github.com/imperiumlabs/GeoFirestore-iOS

class UserController {
    
    //MARK: - Shared Instance
    static let shared = UserController()
    
    //MARK: - Firebase Firestore Database
    let firestoreDB = Firestore.firestore()
    let geoRef = Firestore.firestore().collection("geoFireLocation")
    
    //MARK: - Source of truth
    var user: User?
    var users: [User] = []
    // var users: users = [User]()
    var filteredUsers = [User]()
    var average = 0.0
    var count = 0.0
    
    //MARK: - Properties
    private let locationManager = LocationManager()
    let mapView = MKMapView()
    
    //MARK: - CRUD Functions
    func createUserWith(email: String, username: String, password: String = "", image: UIImage?, isChef: Bool, completion: @escaping (Bool) -> Void) {
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
                storageRef.downloadURL(completion: { (downloadURL, err) in
                    guard let imageUrl = downloadURL?.absoluteString else { return }
                    guard let uid = user?.user.uid else { return }
                    self.firestoreDB.collection(Constants.Users).document(uid).setData([Constants.Email: email, Constants.Username: username, Constants.Uid: uid, Constants.IsChef: isChef, Constants.ProfileImageUrl: imageUrl])
                    let getUser = StripeUser.init(id: uid, customer_id: "", email: email)
                    self.createFirestoreUser(stripeUser: getUser)
                    self.setupGeofirestore(uid: uid)
                    completion(true)
                })
            })
        })
    }
    
    func setupGeofirestore(uid: String) {
        guard let exposedLocation = self.locationManager.exposedLocation else { return }
        self.locationManager.getPlace(for: exposedLocation) { placemark in
            guard let placemark = placemark else { return }
            var output = ""
            if let locationName = placemark.location {
                output = output + "\n\(locationName)"
            }
            self.locationManager.getLocation(forPlaceCalled: output) { location in
                guard let location = location else { return }
                let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                let latitude = center.latitude
                let longitude = center.longitude
                if let postal = placemark.postalAddress {
                    self.setUserLocation(uid, city: postal.city, state: postal.state, latitude: latitude, longitude: longitude) { (result) in
                        switch result {
                        case true:
                            print("success")
                        case false:
                            print("failed to save")
                        }
                    }
                }
            }
        }
    }
    
    func createUserWithProvider(uid: String, email: String, username: String, isChef: Bool, completion: @escaping (Bool) -> Void) {
        
        self.firestoreDB.collection(Constants.Users).document(uid).setData([Constants.Email: email, Constants.Username: username, Constants.Uid: uid, Constants.IsChef: isChef]) { (error) in
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
                print(error.localizedDescription)
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
    
    func fetchUserRatingWith(uid: String, completion: @escaping (Bool) -> Void) {
        firestoreDB.collection(Constants.Users).document(uid).collection(Constants.Ratings).getDocuments() { (querySnapshot, error) in
            var totalCount = 0.0
            if error != nil {
                completion(false)
                print(error?.localizedDescription ?? "")
            } else {
                self.count = Double(querySnapshot?.count ?? 0)
                for document in querySnapshot!.documents {
                    if let rate = document.data()[Constants.Stars] as? Double {
                        totalCount += rate
                        completion(true)
                    }
                }
            }
            self.average = totalCount/self.count
//            self.ratingView.rating = average
        }
    }
    
    func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        firestoreDB.collection(Constants.Users).document(uid).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let dictionary = document.data() else { return }
                let user = User(dictionary: dictionary)
                completion(user)
            } else {
                completion(error as! User)
                print("Document does not exist")
            }
        }
    }

    func fetchUsers(uid: String, completion: @escaping (User) -> Void) {
        firestoreDB.collection(Constants.Users).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(error as! User)
            }
            self.users = []
            snapshot?.documents.forEach({ (document) in
                let dictionary = document.data()
                let uid = dictionary[Constants.Uid] as? String ?? ""
                let isChef = dictionary[Constants.IsChef] as? Bool
                if uid != Auth.auth().currentUser?.uid && isChef == true {
                    let user = User(dictionary: dictionary)
                    self.users.append(user)
                    self.users.sort(by: { (u1, u2) -> Bool in
                        return u1.username!.compare(u2.username!) == .orderedAscending
                    })
                    self.filteredUsers = self.users
                    completion(user)
                }
            })
        }
    }

    func updateUser(_ uid: String, username: String, bio: String, isChef: Bool, completion: @escaping (Bool) -> Void) {
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
    
    func updateChefAccount(_ uid: String, isChef: Bool, completion: @escaping (Bool) -> Void) {
        firestoreDB.collection(Constants.Users).document(uid).setData([Constants.IsChef: isChef], merge: true) { error in
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
    
    func setUserLocation(_ uid: String, street: String = "", apartment: String = "", city: String, state: String, latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        let geoFirestore = GeoFirestore(collectionRef: geoRef)
        geoFirestore.setLocation(geopoint: GeoPoint(latitude: latitude, longitude: longitude), forDocumentWithID: uid) { (error) in
            if let error = error {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
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
            storageRef.child(Constants.ProfileImageUrl).child(filename).downloadURL(completion: { (downloadURL, err) in
                guard let imageUrl = downloadURL?.absoluteString else { return }
                print("image: \(imageUrl)")
                self.firestoreDB.collection(Constants.Users).document(uid).setData([Constants.ProfileImageUrl: imageUrl], merge: true)
                completion(true)
            })
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
