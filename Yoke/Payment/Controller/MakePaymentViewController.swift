//
//  MakePaymentViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class MakePaymentViewController: UIViewController, STPAddCardViewControllerDelegate {
    
    //MARK: Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var booking: Booking? {
        didSet {
            fetchInvoice()
        }
    }
    fileprivate let paymentURL: String = "https://us-central1-foodapp-4ebf0.cloudfunctions.net/createCharge "
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        view.addSubview(paymentMethodButton)
        paymentMethodButton.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 100)
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Payment", largeTitle: false, backgroundColor: .white, titleColor: orange)
    }
    
    func fetchInvoice() {
        guard let booking = booking,
              let paymentId = booking.paymentId,
              let uid = booking.userUid else { return }
    }
    
    //MARK:- STPAdd Card Controller Delegate
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        dismiss(animated: true, completion: nil)
        
        DispatchQueue.main.async {
            self.createPayment(token: token.tokenId, amount: 1000)
        }
    }
    
    //MARK:- Helper Methods
    fileprivate func createPayment(token: String, amount: Float) {
        AF.request(paymentURL, method: .post, parameters: ["stripeToken": token, "amount": amount * 100],encoding: JSONEncoding.default, headers: nil).responseString {
            response in
            switch response.result {
            case .success:
                print("Success create payment \(amount)")
                break
            case .failure(let error):
                
                print("Failure")
            }
        }
    }
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        print("didcreatepaymentwith")
    }
    
    @objc func handlePaymentMethod() {
        let config = STPPaymentConfiguration.shared
        config.requiredBillingAddressFields = .full
        let viewController = STPAddCardViewController(configuration: config, theme: STPTheme.default())
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    var paymentMethodButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Choose Payment Method", for: .normal)
        button.setTitleColor(UIColor.yellowColor(), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handlePaymentMethod), for: .touchUpInside)
        return button
    }()
    
}
