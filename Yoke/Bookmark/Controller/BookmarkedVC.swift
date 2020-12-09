//
//  SavedVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class BookmarkedVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var user: User?
    var uid = Auth.auth().currentUser?.uid
    
    let cellId = "cellId"
    let eventId = "eventId"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(BookmarkedUsersCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView!.register(BookmarkedEventsCell.self, forCellWithReuseIdentifier: eventId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }

        setupViews()
        fetchBookmarkedUserIds()
        fetchEvents()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func handleRefresh() {
        fetchAllSaved()
    }
    
    fileprivate func fetchAllSaved() {
        users.removeAll()
        fetchBookmarkedUserIds()
        events.removeAll()
        fetchEvents()
        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl?.endRefreshing()
        } else {
            // Fallback on earlier versions
        }
    }
    
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Users","Events"])
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
    
    func setupViews() {
        navigationItem.title = "Bookmarked"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.black
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        collectionView!.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }

    var events = [Event]()
    fileprivate func fetchEvents() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child(Constants.BookmarkedEvents).child(currentUserId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
                let eventKey = (child as AnyObject).key as String
                Database.database().reference().child(Constants.Event).child(eventKey).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    guard let dictionary = snapshot.value as? [String: Any] else {return}
                    guard let uid = dictionary[Constants.Uid] as? String else {return}
                    
                    Database.fetchUserWithUID(uid: uid, completion: { (user) in
                        let event = Event(user: user, dictionary: dictionary, snapshot: snapshot)
                        self.events.append(event)
                        self.events.sort(by: { (event1, event2) -> Bool in
                            return event1.eventDate?.compare(event2.eventDate!) == .orderedAscending
                        })
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                        
                    })
                    
                })
            }
        })
    }

    var users = [User]()
    fileprivate func fetchBookmarkedUserIds() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchUsers(user: user)
        }
    }
    
    fileprivate func fetchUsers(user: User) {
        
//        if #available(iOS 10.0, *) {
//            self.collectionView?.refreshControl?.endRefreshing()
//        } else {
//            // Fallback on earlier versions
//        }
        
        let ref = Database.database().reference().child(Constants.Users)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                guard let userDictionary = value as? [String: Any] else { return }
                Database.database().reference().child(Constants.BookmarkedUsers).child(self.uid!).child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1 {
                         let user = User(uid: key, dictionary: userDictionary)
                        self.users.append(user)
                        self.users.sort(by: { (u1, u2) -> Bool in
                            return u1.username.compare(u2.username) == .orderedAscending
                        })
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
    
                })
                
            })
            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return users.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return events.count
        }
        
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if segmentedControl.selectedSegmentIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventId, for: indexPath) as! BookmarkedEventsCell
            cell.event = events[indexPath.item]
            cell.user = self.user
            return cell
        } else if segmentedControl.selectedSegmentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookmarkedUsersCell
            cell.user = users[indexPath.item]
            return cell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            let user = users[indexPath.row]
            let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileVC.userId = user.uid
            navigationController?.pushViewController(userProfileVC, animated: true)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let event = events[indexPath.row]
            let eventDetailVC = EventDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
            eventDetailVC.event = event
            navigationController?.pushViewController(eventDetailVC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 1
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 20
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 1
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 20
        }
        return 1
    }

}
