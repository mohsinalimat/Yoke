//
//  PaymentsVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 5/7/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class PaymentsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, PaymentProfileHeaderDelegate {
    
    var user: User?
    let reuseIdentifier = "Cell"
    let headerId = "headerId"
    let cellId = "cellId"
    var totalIncome: Double = 0.0
    var totalSpent: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Payments"
        collectionView.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true

        collectionView?.register(PaymentHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//        self.collectionView!.register(InvoiceCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(PaymentCell.self, forCellWithReuseIdentifier: cellId)

        setupViews()
        fetchInvoices()

    }
    
    func setupViews() {
        
        collectionView.addSubview(historyLabel)
        historyLabel.anchor(top: collectionView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 130, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        collectionView.addSubview(segmentedControl)
        segmentedControl.anchor(top: historyLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 35)
    }
    
    let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "Payment History"
        label.textColor = UIColor.darkGray
        label.layer.backgroundColor = UIColor.white.cgColor
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Earnings", "Pay"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = UIColor.orangeColor()
        seg.tintColor = UIColor.white
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        seg.addTarget(self, action: #selector(getSegments), for: .valueChanged)
        return seg
    }()

    @objc func getSegments(index: Int) {
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView?.reloadData()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            collectionView?.reloadData()
        }
    }

    var earnings = [Payment]()
    var payments = [Payment]()
    fileprivate func fetchInvoices() {
//        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//        let ref = Database.database().reference().child(Constants.Invoices).child(currentUserId)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            for child in snapshot.children {
//                let invoiceKey = (child as AnyObject).key as String
//                Database.database().reference().child(Constants.Payments).child(invoiceKey).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                    guard let dictionary = snapshot.value as? [String: Any] else {return}
//                    guard let uid = dictionary[Constants.FromUser] as? String else {return}
//
//                    Database.fetchUserWithUID(uid: uid, completion: { (user) in
//                        let payment = Payment(user: user, dictionary: dictionary, snapshot: snapshot)
//                        self.payments.append(payment)
//
//                        self.payments.sort(by: { (event1, event2) -> Bool in
//                            return event1.eventDate?.compare(event2.eventDate!) == .orderedAscending
//                        })
//
//                        self.earnings = self.payments
//                        DispatchQueue.main.async {
//                            self.collectionView?.reloadData()
//                        }
//
//                    })
//
//                })
//            }
//        })
    }

    func viewHandleStripe() {
        let withdrawl = WithdrawlVC()
        navigationController?.pushViewController(withdrawl, animated: true)
    }
    
    func viewCreateInvoice() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docRef = Firestore.firestore().collection(Constants.StripeAccounts).document(uid)
            
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
//                let invoice = CreateInvoiceVC()
//                self.navigationController?.pushViewController(invoice, animated: true)

            } else {
                let vc = StripeSignupVC()
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    func paymentsView(text: String) {
//        payments = self.payments.filter({ (payments) -> Bool in
//            payments.toUser.lowercased().contains(text.lowercased())
//        })
    }

    func earningsView(text: String) {
//        earnings = self.earnings.filter({ (earnings) -> Bool in
//            earnings.fromUser.lowercased().contains(text.lowercased())
//        })
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            earningsView(text: Auth.auth().currentUser?.uid ?? "")
            return earnings.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            paymentsView(text: Auth.auth().currentUser?.uid ?? "")
            return payments.count
        }

        return payments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        if segmentedControl.selectedSegmentIndex == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InvoiceCell
//            cell.payment = earnings[indexPath.item]
//            cell.user = self.user
//            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PaymentCell
            cell.payment = payments[indexPath.item]
            cell.user = self.user
            return cell
        }

        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: cell.frame.height, width: cell.frame.width, height: 0.5)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        cell.layer.addSublayer(bottomLine)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 95)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let uid = Auth.auth().currentUser?.uid else {return}

//        if uid == payments[indexPath.item].fromUser {
//            let data = earnings[indexPath.item]
//            let vc = PaymentDetailVC()
//            vc.payment = data
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let data = payments[indexPath.item]
//            let vc = MakePaymentVC()
//            vc.payment = data
//            self.navigationController?.pushViewController(vc, animated: true)
//        }

    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PaymentHeaderCell
        header.delegate = self

        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 220)
    }

}



