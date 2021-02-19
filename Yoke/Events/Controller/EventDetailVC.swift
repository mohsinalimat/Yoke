//
//  EventDetailVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class EventDetailVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    var userId: String?
    var eventId: String?
    var user: User? {
        didSet {
            
        }
    }
    
    var event: Event? {
        didSet {
            eventId = event?.id
        }
    }
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchEvent()
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(EventDetailCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellId)
//        fetchUser()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.orangeColor()
        
        collectionView?.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }

    var events = [Event]()
    fileprivate func fetchEvent() {
        guard let uid = self.user?.uid else {return}
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchEventWithUser(user: user)
        }
    }
    
    fileprivate func fetchEventWithUser(user: User) {
        let getPostId = self.event?.id
//        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = Database.database().reference().child(Constants.Event).child(getPostId!)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }

            dictionaries.forEach({ (key, value) in
                guard let dictionary = value as? [String: Any] else { return }
                let event = Event(user: user, dictionary: dictionary, snapshot: snapshot)
                event.id = key
                self.events.append(event)
                self.collectionView?.reloadData()
            })
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }


    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellId, for: indexPath) as! EventDetailCell
        cell.event = self.event
        if event?.eventImageUrl == "" {
            cell.photoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        cell.profileImageView.isUserInteractionEnabled = true
        cell.messageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let rect = NSString(string: (self.event?.postText)!).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        
        if event?.eventImageUrl == "" {
            let knownHeight: CGFloat = view.frame.width + 200
            return CGSize(width: view.frame.width, height: rect.height + knownHeight)
        }
        
        let knownHeight: CGFloat = 65 + view.frame.width + 200
        return CGSize(width: view.frame.width, height: rect.height + knownHeight)
    }
    
    @objc func imageTapped() {
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.userId = event?.uid
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    @objc func sendMessage() {
//        print("message tapped")
//        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
//        chatVC.user = event?.user
//        navigationController?.pushViewController(chatVC, animated: true)
    }

}
