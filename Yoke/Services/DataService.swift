//
//  DataService.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import Firebase

protocol FetchData: class {
    func dataReceived(contacts: [User])
}

class DataService {
    
    private static let _instance = DataService()
    private init() {}
    static var instance: DataService {
        return _instance
    }
    
    weak var delegate: FetchData?
    
    private var _profileImgRef = "imageUrl"
    
    let uid = Auth.auth().currentUser?.uid
    var imageURL: URL?
    
    let ref = Database.database().reference()
    
    func registerUserIntoDatabaseWithUID(uid: String, values: Dictionary<String, Any>) {
        ref.child(Constants.Users).updateChildValues(values)
        
    }
    
    func updateUserValues(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "")
        
        let usersReference = ref.child(Constants.Users).child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("error")
            }
        })
    }
    
    func updatePostValues(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference().child(Constants.Event).queryOrdered(byChild: Constants.Uid).queryEqual(toValue: uid)
        ref.setValue(values, forKey: uid)
        
    }
    
    func updateScheduleValues(key: String, values: [String: AnyObject]) {
        let ref = Database.database().reference().child(Constants.Calendar).queryOrdered(byChild: Constants.Id).queryEqual(toValue: key)
        ref.setValue(values, forKey: key)
    }
    
    func resetPassword(_ email: String){
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                print("An email to reset your password has been sent to your email.")
                self.showAlertMessage(title: "Great!", message: "An email to reset your password has been sent to your email.")
            }else {
                print(error!.localizedDescription)
                
            }
        })
        
    }
    
    private func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
    }
    
    
}
