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
import SafariServices

let BackendAPIBaseURL: String = "https://foodapp-4ebf0.firebaseapp.com" // Set to the URL of your backend server

class CreateStripeAccountVC: UIViewController, SFSafariViewControllerDelegate {
        override func viewDidLoad() {
            super.viewDidLoad()

            let connectWithStripeButton = UIButton(type: .system)
            connectWithStripeButton.setTitle("Connect with Stripe", for: .normal)
            connectWithStripeButton.addTarget(self, action: #selector(didSelectConnectWithStripe), for: .touchUpInside)
            view.addSubview(connectWithStripeButton)
            connectWithStripeButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: 50)

            // ...
        }

        @objc
        func didSelectConnectWithStripe() {
            print("pressed")
            if let url = URL(string: BackendAPIBaseURL)?.appendingPathComponent("onboard-user") {
              var request = URLRequest(url: url)
              request.httpMethod = "POST"
              let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                  guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                      let accountURLString = json["url"] as? String,
                      let accountURL = URL(string: accountURLString) else {
                          return
                  }

                  let safariViewController = SFSafariViewController(url: url)
                  safariViewController.delegate = self

                  DispatchQueue.main.async {
                      self.present(safariViewController, animated: true, completion: nil)
                  }
              }
            }
        }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // the user may have closed the SFSafariViewController instance before a redirect
        // occurred. Sync with your backend to confirm the correct state
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(webWarning)
//        webWarning.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//    }
//
//    let webWarning: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.darkGray
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.text = "You are about to leave FooD the App and redirected to Stripe Login"
//        return label
//    }()
//
//    func checkIfAccountexist() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let docRef = Firestore.firestore().collection(Constants.StripeAccounts).document(uid)
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let data = document.data()
//                let stripeUrl = data!["stripeLoginLink"] as? String ?? ""
//                print("Document data: \(stripeUrl)")
//                guard let url = URL(string: stripeUrl) else {return}
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            } else {
//                print("Document does not exist")
//                guard let url = URL(string: "https://foodapp-4ebf0.firebaseapp.com") else {return}
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//
//
//            }
//        }
//    }
   
}
