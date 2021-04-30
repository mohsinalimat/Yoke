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
import WebKit
import Alamofire

class CreateStripeAccountVC: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    
    var webView: WKWebView!
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    //replace this with your Heroku hosted Node.js App url
    let url = URL(string: "https://foodapp-4ebf0.web.app")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
//        activityIndicatorView.isHidden = true
        
        guard let url = self.url else {
            self.alert(message: "The URL seems to be Invalid.")
            return
        }
        
        let path: String = "/authorize"
        
        let cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        let timeout: TimeInterval = 6.0
        var request = URLRequest(url: url.appendingPathComponent(path), cachePolicy: cachePolicy, timeoutInterval: timeout)
        
        request.httpMethod = "GET"
        
//        activityIndicatorView.isHidden = false
        webView.load(request)
        
    }
    
    func webViewDidStartLoad(_ webView: WKWebView) {
        activityIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: WKWebView) {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailLoadWithError error: Error) {
        self.alert(message: error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, shouldStartLoadWith request: URLRequest, navigationType: WKNavigationType) -> Bool {
        if let url = request.url {
            
            if let urlComponents = URLComponents(string: url.absoluteString) {
                if let queryString = urlComponents.queryItems {
                    for query in queryString {
                        if query.name == "stripe_user_id" {
                            if let value = query.value {
                                
                                //If authentication to your Stripe Account was successful, the Stripe User ID will be returned as a query string in the variable 'value'.  You can then proceed to save it to your application’s database, to use at a later stage for any subsequent Stripe connection requests.
                                
                                print("Stripe User ID = \(value)")
                            }
                        }
                    }
                }
            }
        }
        return true
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(action)
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.present(alertController, animated: true, completion: nil)
        })
    }

}

//class CreateStripeAccountVC: UIViewController, WKNavigationDelegate, WKUIDelegate  {
//    var accountId: String = ""
//    var webView: WKWebView!
//    var activityIndicator: UIActivityIndicatorView!
//    override func loadView() {
//            let webConfiguration = WKWebViewConfiguration()
//            webView = WKWebView(frame: .zero, configuration: webConfiguration)
//            webView.uiDelegate = self
//            view = webView
//        }
//
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            let myURL = URL(string: "https://foodapp-4ebf0.web.app")
//            let myRequest = URLRequest(url: myURL!)
//            webView.load(myRequest)
//        }
//
//        func webView(
//            _ webView: WKWebView,
//            decidePolicyFor navigationAction: WKNavigationAction,
//            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//
//            guard let url = navigationAction.request.url else {
//                decisionHandler(.allow)
//                return
//            }
//
//            if url.absoluteString.contains("createConnectAccount") {
//
//                decisionHandler(.cancel)
//                _ = self.navigationController?.popViewController(animated: false)
//            }
//            else {
//                decisionHandler(.allow)
//            }
//        }
//
//    override func loadView() {
//        webView = WKWebView()
//        webView.navigationDelegate = self
//        webView.uiDelegate = self
//        view = webView
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        checkIfAccountexist()
//        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
//        toolbarItems = [refresh]
//        navigationController?.isToolbarHidden = true
//
//        activityIndicator = UIActivityIndicatorView()
//        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
//        activityIndicator.center = self.webView.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.color = UIColor.orangeColor()
//
//        webView.addSubview(activityIndicator)
//        activityIndicator.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//
//    }
//
//    func showActivityIndicator(show: Bool) {
//        if show {
//            activityIndicator.startAnimating()
//        } else {
//            activityIndicator.stopAnimating()
//        }
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        showActivityIndicator(show: false)
//    }
//
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        showActivityIndicator(show: true)
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        showActivityIndicator(show: false)
//    }
//
//    var customView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        view.layer.cornerRadius = 5
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.8
//        view.layer.shadowOffset = .zero
//        view.layer.shadowRadius = 6
//        return view
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
//                self.webView.load(URLRequest(url: url))
//
//            } else {
//                print("Document does not exist")
//                guard let url = URL(string: "https://foodapp-4ebf0.firebaseapp.com") else {return}
//                self.webView.load(URLRequest(url: url))
//            }
//        }
//    }

//}
// strip express link: https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://foodapp-4ebf0.firebaseapp.com/token&client_id=ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO&state={STATE_VALUE}


//let BackendAPIBaseURL: String = "https://connect.stripe.com/express/oauth/authorize?redirect_uri=https://us-central1-foodapp-4ebf0.cloudfunctions.net/createConnectAccount&client_id=ca_FJy4SUnn4WnkK81JVAR5CZhwEACACSIO&state={STATE_VALUE}"
//class CreateStripeAccountVC: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let connectWithStripeButton = UIButton(type: .system)
//        connectWithStripeButton.setTitle("Connect with Stripe", for: .normal)
//        connectWithStripeButton.addTarget(self, action: #selector(didSelectConnectWithStripe), for: .touchUpInside)
//        view.addSubview(connectWithStripeButton)
//        connectWithStripeButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, height: 50)
//
//        // ...
//    }
//
//    @objc
//    func didSelectConnectWithStripe() {
//        if let url = URL(string: BackendAPIBaseURL)?.appendingPathComponent("onboard-user") {
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                guard let data = data,
//                      let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
//                      let accountURLString = json["url"] as? String,
//                      let accountURL = URL(string: accountURLString) else {
//                    return
//                }
//
//                let safariViewController = SFSafariViewController(url: url)
//                safariViewController.delegate = self
//
//                DispatchQueue.main.async {
//                    self.present(safariViewController, animated: true, completion: nil)
//                }
//            }
//        }
//    }
//
//    // ...
//}
//
//extension CreateStripeAccountVC: SFSafariViewControllerDelegate {
//    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
//        // the user may have closed the SFSafariViewController instance before a redirect
//        // occurred. Sync with your backend to confirm the correct state
//    }
//}
