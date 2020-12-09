//
//  MakePaymentVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 5/17/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Stripe
import FirebaseFunctions
import Firebase

class MakePaymentVC: UIViewController, STPPaymentContextDelegate {

    private let stripeFee = 0.0
    private let flatFeeCents = 30.00
    private let fee = 20.00
    var paymentContext: STPPaymentContext!
    var paymentId: String = ""
    var stripeId: String = ""
    var customerId: String = ""
    var customerUID: String = ""
    var chefUID: String?
    var totalAmount: Int = 0
    var feesAmount: Int = 0
    var activityIndicator: UIActivityIndicatorView!
    
    var payment: Payment? {
        didSet {
            let amount = payment?.amount
            totalAmount = amount!
            chefUID = payment?.fromUser ?? ""
            customerUID = payment?.toUser ?? ""
            paymentId = payment?.key ?? ""
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.backgroundColor = .white
        setupViews()
        setupStripe()
        getStripeCustomerId()
        getStripeId()
        setupActivityIndicator()
//        getChefId()
    }
    
    func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.orangeColor()

        view.addSubview(activityIndicator)
        activityIndicator.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    var subtotal: Int {
        var amount = 0
        let pricePennies = Int(totalAmount * 100)
        amount += pricePennies
        return amount
    }
    
    var processingFees : Int {
        if subtotal == 0 {
            return 0
        }
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeFee + fee + flatFeeCents)
        feesAmount = feesAndSub
        return feesAndSub
    }
    
    var total : Int {
        return subtotal + processingFees
//        return Int(totalAmount * 100)
    }
    
    func setupStripe() {
        let config = STPPaymentConfiguration.shared()
//        config.createCardSources = true
        config.requiredBillingAddressFields = .full
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        paymentContext.paymentAmount = Int(total)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
 
        subLabel.text = subtotal.penniesToFormattedCurrency()
        feeLabel.text = self.processingFees.penniesToFormattedCurrency()
        totalLabel.text = self.total.penniesToFormattedCurrency()
        
    }
    
    func getStripeCustomerId() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            Firestore.firestore().collection("stripe_customers").document(self.customerUID).addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                let document = snapshot?.data()
                let id = document?["customer_id"] as! String
                self.customerId = id
                print("customer id \(self.customerId)")
            })
        }
    }
    
    func getStripeId() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Database.fetchUserWithUID(uid: uid) { (user) in
            Firestore.firestore().collection("StripeAccounts").document(self.chefUID!).addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                let document = snapshot?.data()
                let id = document?["stripeId"] as! String
                self.stripeId = id
            })
        }
    }
    
    
//    func getChefId() {
//        guard let uid = chefUID else {return}
//        Database.fetchUserWithUID(uid: uid) { (user) in
//            Firestore.firestore().collection(Constants.Users).document(uid).addSnapshotListener({ (snapshot, error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//                let document = snapshot?.data()
//                let id = document?[Constants.StripeId] as! String
//                self.chefStripeId = id
//            })
//        }
//    }
    
    func setupViews() {
        
        let subView = UIStackView(arrangedSubviews: [subTitle, subLabel])
        subView.distribution = .fillEqually
        subView.axis = .horizontal
        subView.spacing = 1
        view.addSubview(subView)
        subView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: 0, height: 30)
        
        let feeView = UIStackView(arrangedSubviews: [feeTitle, feeLabel])
        feeView.distribution = .fillEqually
        feeView.axis = .horizontal
        feeView.spacing = 1
        view.addSubview(feeView)
        feeView.anchor(top: subView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: 0, height: 30)
        
        let totalView = UIStackView(arrangedSubviews: [totalTitle, totalLabel])
        totalView.distribution = .fillEqually
        totalView.axis = .horizontal
        totalView.spacing = 1
        view.addSubview(totalView)
        totalView.anchor(top: feeView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 25, paddingBottom: 0, paddingRight: 25, width: 0, height: 30)
        
        view.addSubview(paymentMethodTitle)
        paymentMethodTitle.anchor(top: totalView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
        
        view.addSubview(paymentMethodButton)
        paymentMethodButton.anchor(top: totalView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 25, paddingBottom: 20, paddingRight: 25, width: 0, height: 0)
        
        view.addSubview(payButton)
        payButton.anchor(top: paymentMethodButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 20, paddingRight: 10, width: 0, height: 50)
    }
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subTitle: UILabel = {
        let label = UILabel()
        label.text = "Subtotal"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let feeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let feeTitle: UILabel = {
        let label = UILabel()
        label.text = "Processing Fee"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let totalTitle: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let paymentMethodTitle: UILabel = {
        let label = UILabel()
        label.text = "Paying With"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var paymentMethodButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Choose Payment Method", for: .normal)
        button.setTitleColor(UIColor.yellowColor(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handlePaymentMethod), for: .touchUpInside)
        return button
    }()
    
    
    var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Choose Payment", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.yellowColor()?.withAlphaComponent(0.5)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleMakePayment), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePaymentMethod() {
//        paymentContext.pushPaymentMethodsViewController()
        paymentContext.pushPaymentOptionsViewController()
    }
    
    @objc func handleMakePayment() {
        paymentContext.requestPayment()
        showActivityIndicator(show: true)
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        let retry = UIAlertAction(title: "Retry", style: .default) { (action) in
            self.paymentContext.retryLoading()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(retry)
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPPaymentStatusBlock) {
        
        let idempotency = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        
        let data : [String: Any] = [
            "total_amount" : totalAmount,
            "customer_id" : customerId,
            "payment_method_id" : paymentResult.paymentMethod?.stripeId,
            "idempotency" : idempotency,
            "destination" : stripeId
        ]
                
        Functions.functions().httpsCallable("createCharge").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
//                self.simpleAlert(title: "Error", msg: "Unable to make charge.")
                completion(STPPaymentStatus.error, error)
                return
            }
            self.showActivityIndicator(show: false)
            completion(.success, nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
        let title: String
        let message: String
        
        switch status {
        case .error:
            title = "Error"
            message = error?.localizedDescription ?? ""
        case .success:
            title = "Success!"
            message = "Thank you for your payment"
            paymentStatus()
        case .userCancellation:
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func paymentStatus() {
        guard let paymentId = payment?.key else { return  }
        let ref = Database.database().reference().child(Constants.Payments).child(paymentId)
        ref.observe(.value) { (snapshot) in
            let values = [Constants.Status: "Payment Approved"]
            ref.updateChildValues(values)
        }
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let paymentMethod = paymentContext.selectedPaymentOption {
            paymentMethodButton.setTitle(paymentMethod.label, for: .normal)
            paymentMethodButton.setTitleColor(UIColor.orangeColor(), for: .normal)
            payButton.setTitle("Pay \(self.total.penniesToFormattedCurrency())", for: .normal)
            payButton.backgroundColor = UIColor.yellowColor()?.withAlphaComponent(1.0)
        } else {
//            paymentMethodButton.setTitle("Select Method test", for: .normal)
        }
    }
    
}
