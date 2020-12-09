//
//  EditEventVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase


class EditEventVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let noCellId = "noCellId"
    let uid = Auth.auth().currentUser?.uid
    var user: User?
    fileprivate func fetchUser() {
        guard let uid = self.user?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        self.collectionView!.register(EditEventCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
        collectionView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        view.backgroundColor = UIColor.white
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            collectionView?.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }

        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdate), name: EditEventDetailVC.updateNotificationName, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdate), name: NewEventVC.updateNotificationName, object: nil)
        setupNavTitleAndBarButtonItems()
        fetchAllEvents()
    }
    
    @objc func handleUpdate() {
        handleRefresh()
    }
    
    @objc func handleRefresh() {
        fetchAllEvents()
    }
    
    fileprivate func fetchAllEvents() {
        events.removeAll()
        fetchUser()
        fetchEvent()
    }

    func setupNavTitleAndBarButtonItems() {
        self.navigationItem.title = "Your Events"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Event", style: .plain, target: self, action: #selector(handleNewEvent))
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor()
        return view
    }()
    
    @objc func handleNewEvent() {
        let newEvent = NewEventVC()
        let navController = UINavigationController(rootViewController: newEvent)
        present(navController, animated: true, completion: nil)
    }
    
    @objc func editDeleteEvent(sender: UIButton){
        
        let alertController = UIAlertController(title: "Please Choose an Action", message: "Delete Event or Edit Event", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            let item = sender.tag
            let indexPath = IndexPath(item: item, section: 0)
            let eventKey = self.events[indexPath.item].key!
            
            Database.database().reference().child(Constants.Event).child(eventKey).removeValue()

            Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).observe(.value, with: { (snapshot) in
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                dictionaries.forEach({ (key, value) in
                    Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).child(key).observe(.value, with: { (snapshot) in
                        
                        guard let dictionary = value as? [String: Any] else { return }
                        let eventId  = dictionary[Constants.Event] as? String
                    
                        if eventId == eventKey {
                            Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).child(key).removeValue()
                        }
                    })
                })
            })
            self.events.remove(at: indexPath.item)
            self.collectionView.reloadData()

        }
        alertController.addAction(destroyAction)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { action in
            let item = sender.tag
            let indexPath = IndexPath(item: item, section: 0)
            let event = self.events[indexPath.row]
            let editEventDetailVC = EditEventDetailVC()
            editEventDetailVC.event = event
            self.navigationController?.pushViewController(editEventDetailVC, animated: true)
            
        }
        alertController.addAction(editAction)
        
        self.present(alertController, animated: true) {
        }
    }
    
    var events = [Event]()
    fileprivate func fetchEvent() {
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Event).queryOrdered(byChild: Constants.Uid).queryEqual(toValue: currentUser)
        
        ref.observe(.childAdded, with: { (snapshot) in
            if #available(iOS 10.0, *) {
                self.collectionView?.refreshControl?.endRefreshing()
            } else {
                // Fallback on earlier versions
            }
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
            noCell.photoImageView.image = UIImage(named: "no_post_background")! 
            noCell.noPostLabel.text = "You have no events"
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EditEventCell
        cell.event = events[indexPath.item]
        cell.editButton.tag = indexPath.item
        cell.editButton.addTarget(self, action: #selector(editDeleteEvent), for: .touchUpInside)
        
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
        
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 5, y: cell.frame.height, width: cell.frame.width, height: 0.5)
//        bottomLine.backgroundColor = UIColor.lightGray.cgColor
//        cell.layer.addSublayer(bottomLine)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if events.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.noPostLabel.text = "You have no events"
            return CGSize(width: view.frame.width, height: 75)
        } else {
            if let statusText = events[indexPath.item].postText {
                
                let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)

                if events[indexPath.item].eventImageUrl == "" {
                    let knownHeight: CGFloat = 10 + 1 + 110
                    return CGSize(width: view.frame.width, height: rect.height + knownHeight)
                }
                
                let knownHeight: CGFloat = 10 + 200 + 95
                return CGSize(width: view.frame.width, height: rect.height + knownHeight)

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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 20)
    }
}

