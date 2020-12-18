//
//  FirebaseUtil.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import Firebase

extension Database {

    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
//        Database.database().reference().child(Constants.Users).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            guard let userDictionary = snapshot.value as? [String: Any] else { return }
//            let user = User(uid: <#String#>, id: <#String#>, customer_id: <#String#>, email: <#String#>, username: <#String#>, profileImageUrl: <#String#>, profileCoverUrl: <#String#>, location: <#String#>)
//            completion(user)
//            
//        }) { (err) in
//            print("Failed to fetch user:", err)
//        }
    }
    
    static func userIsChef(userKey: String, completion: @escaping (_ userTitle: Bool?) -> Void) {
        Database.database().reference().child(Constants.Chefs).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(userKey) {
                completion(true)
            } else {
                completion(false)
            }
        }, withCancel: nil)
    }
}

extension Auth {
    func handleFirebaseErrors(error: Error, vc: UIViewController) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            vc.present(alert, animated: true, completion: nil)
        }
    }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
            
        default:
            return "Sorry, something went wrong."
        }
    }
}
