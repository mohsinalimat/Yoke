//
//  CreateStripeAccountVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/12/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreateStripeAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webWarning)
        webWarning.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    let webWarning: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "You are about to leave FooD the App and redirected to Stripe Login"
        return label
    }()
    
    func checkIfAccountexist() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection(Constants.StripeAccounts).document(uid)
            
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let stripeUrl = data!["stripeLoginLink"] as? String ?? ""
                print("Document data: \(stripeUrl)")
                guard let url = URL(string: stripeUrl) else {return}
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                print("Document does not exist")
                guard let url = URL(string: "https://foodapp-4ebf0.firebaseapp.com") else {return}
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                        
                    
            }
        }
    }
   
}
