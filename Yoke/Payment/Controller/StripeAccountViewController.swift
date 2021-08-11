//
//  StripeAccountViewController.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/12/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import WebKit

class StripeAccountViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfAccountExist()
        view.addSubview(myActivityIndicator)
        myActivityIndicator.center = view.center
    }
    
    func checkIfAccountExist() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection(Constants.StripeAccounts).document(uid)
        myActivityIndicator.startAnimating()
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let data = document.data()
//                let stripeUrl = data!["stripeLoginLink"] as? String ?? ""
                let stripeDashboard = "https://dashboard.stripe.com/login"
                guard let url = URL(string: stripeDashboard) else {return}
                self.webView.load(URLRequest(url: url))
                self.webView.allowsBackForwardNavigationGestures = true
                self.myActivityIndicator.stopAnimating()
            } else {
                guard let url = URL(string: "") else {return}
                self.webView.load(URLRequest(url: url))
                self.webView.allowsBackForwardNavigationGestures = true
                self.myActivityIndicator.stopAnimating()
            }
        }
    }
}
