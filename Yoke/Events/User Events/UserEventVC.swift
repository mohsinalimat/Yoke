//
//  UserEventVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class UserEventVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let noCellId = "noCellId"
    let uid = Auth.auth().currentUser?.uid
    var event: Event?
    var user: User?
    fileprivate func fetchUser() {
        guard let uid = self.user?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = "\(user.username) Events"
            self.collectionView?.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        self.collectionView!.register(UserEventCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
        collectionView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        view.backgroundColor = UIColor.white
        
        fetchUser()
        fetchEvent()
        setupNavTitleAndBarButtonItems()
    }
    
    func setupNavTitleAndBarButtonItems() {
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
    var events = [Event]()
    fileprivate func fetchEvent() {
        let currentUser = self.user?.uid
        let ref = Database.database().reference().child(Constants.Event).queryOrdered(byChild: Constants.Uid).queryEqual(toValue: currentUser)

        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let event = Event(user: user, dictionary: dictionary, snapshot: snapshot)
            self.events.append(event)
            self.events.sort(by: { (event1, event2) -> Bool in
                return event1.creationDate?.compare(event2.creationDate!) == .orderedDescending
            })
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch ordered posts:", err)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if events.count == 0 {
            return 1
        } else {
            return events.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if events.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.noPostLabel.text = "\(user?.username ?? "") has no events"
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserEventCell
        cell.event = events[indexPath.item]
        cell.postTextView.isUserInteractionEnabled = false
        cell.messageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        if events[indexPath.item].eventImageUrl == "" {
            cell.photoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 1)
        }
        
        cell.backgroundColor = UIColor.white
        
        cell.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if events.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.noPostLabel.text = "\(String(describing: user?.username)) has no events"
            return CGSize(width: view.frame.width, height: 75)
        } else {
            if let statusText = events[indexPath.item].postText {
                
                let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
                
                if events[indexPath.item].eventImageUrl == "" {
                    let knownHeight: CGFloat = view.frame.width + 1 + 110
                    return CGSize(width: view.frame.width, height: knownHeight + rect.height)
                }
                
                let knownHeight: CGFloat = view.frame.width
                return CGSize(width: view.frame.width , height: knownHeight + rect.height)
            }
            
            return CGSize(width: view.frame.width, height: 500)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    @objc func sendMessage() {
//        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
//        chatVC.user = event?.user
//        navigationController?.pushViewController(chatVC, animated: true)
    }

}
