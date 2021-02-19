//
//  MessageVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class MessageVC: UITableViewController {
    
//    let notiCellId = "notiCellId"
//    let cellId = "cellId"
//    var userId: String?
//    var message: Message?
//    var notification: Notifications?
//    var user: User?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.white
//        tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
//        tableView.register(NotificationCell.self, forCellReuseIdentifier: notiCellId)
//        fetchUserAndSetupNavBarTitle()
//        fetchNotifications()
//        tableView.allowsSelectionDuringEditing = true
//        self.tableView.separatorStyle = .none
//        setupViews()
//        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        if #available(iOS 10.0, *) {
//            tableView?.refreshControl = refreshControl
//        } else {
//            // Fallback on earlier versions
//        }
//        
//    }
//    
//    @objc func handleRefresh() {
//        tableView?.reloadData()
//        if #available(iOS 10.0, *) {
//            self.tableView?.refreshControl?.endRefreshing()
//        } else {
//            
//        }
//    }
//    
//    let segmentedControl: UISegmentedControl = {
//        let seg = UISegmentedControl(items: ["Messages","Notifications"])
//        seg.selectedSegmentIndex = 0
//        seg.backgroundColor = UIColor.orangeColor()
//        seg.tintColor = UIColor.white
//        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
//        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
//        seg.addTarget(self, action: #selector(getSegments), for: .valueChanged)
//        return seg
//    }()
//    
//    @objc func getSegments(index: Int) {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            tableView.reloadData()
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            tableView.reloadData()
//        }
//    }
//    
//    func setupViews() {
//        tableView.addSubview(segmentedControl)
//        segmentedControl.anchor(top: tableView.topAnchor, left: tableView.leftAnchor, bottom: nil, right: tableView.rightAnchor, paddingTop: -35, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: tableView.frame.width - 10, height: 35)
//        
//        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
//    }
//    
//    var notifications = [Notifications]()
//    func fetchNotifications() {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        let ref = Database.database().reference().child("notifications").child(uid)
//        ref.observe(.childAdded, with: { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            print(dictionary)
//            Database.fetchUserWithUID(uid: uid, completion: { (user) in
//                let notification = Notifications(user: user, dictionary: dictionary, snapshot: snapshot)
//                self.notifications.append(notification)
//                self.tableView.reloadData()
//                self.notifications.sort(by: { (n1, n2) -> Bool in
//                    return n1.creationDate?.compare(n2.creationDate!) == .orderedDescending
//                })
//            })
//                    
//        })
//    }
//    
//    var messages = [Message]()
//    var messageDictionary = [String: Message]()
//    
//    func observeUserMessages() {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        
//        let ref = Database.database().reference().child(Constants.UserMessages).child(uid)
//        ref.observe(.childAdded, with: { (snapshot) in
//            
//            let userId = snapshot.key
//            Database.database().reference().child(Constants.UserMessages).child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
//                
//                let messageId = snapshot.key
//                self.fetchMessageWithMessageId(messageId: messageId)
//                
//            }, withCancel: nil)
//            
//            
//        }, withCancel: nil)
//        
//        ref.observe(.childRemoved, with: { (snapshot) in
//            self.messageDictionary.removeValue(forKey: snapshot.key)
//            self.attemptReloadOfTable()
//        }, withCancel: nil)
//        
//    }
//    
//    private func fetchMessageWithMessageId(messageId: String) {
//        let messagesReference = Database.database().reference().child(Constants.Messages).child(messageId)
//        
//        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            if let dictionary = snapshot.value as? [String: AnyObject] {
//                let message = Message(dictionary: dictionary)
//                
//                if let chatPartnerId = message.chatPartnerId() {
//                    self.messageDictionary[chatPartnerId] = message
//                }
//                
//                self.attemptReloadOfTable()
//                
//            }
//            
//        }, withCancel: nil)
//    }
//    
//    private func attemptReloadOfTable() {
//        self.timer?.invalidate()
//        
//        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
//    }
//    
//    var timer: Timer?
//    
//    @objc func handleReloadTable() {
//        self.messages = Array(self.messageDictionary.values)
//        self.messages.sort(by: { (message1, message2) -> Bool in
//            return (message1.creationDate)! > (message2.creationDate)!
//        })
//        DispatchQueue.main.async(execute: {
//            self.tableView.reloadData()
//        })
//    }
//    
//    func showChatVCforUser(_ user: User) {
//        print(user.username)
//        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
//        chatVC.user = user
//        navigationController?.pushViewController(chatVC, animated: true)
//        
//    }
//    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            guard let uid = Auth.auth().currentUser?.uid else {
//                return
//            }
//            
//            let message = self.messages[indexPath.row]
//            
//            if let chatPartnerId = message.chatPartnerId() {
//                Database.database().reference().child(Constants.UserMessages).child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
//                    
//                    if error != nil {
//                        print("Failed to delete message:", error!)
//                        return
//                    }
//                    
//                    self.messageDictionary.removeValue(forKey: chatPartnerId)
//                    self.attemptReloadOfTable()
//                })
//            }
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            guard let uid = Auth.auth().currentUser?.uid else {return}
//            let key = notifications[indexPath.row].key!
//            let ref = Database.database().reference().child("notifications").child(uid).child(key)
//            ref.removeValue()
//        }
//  
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            if messages.count == 0 {
//                tableView.setEmptyView(title: "You have no messages", message: "Start chatting now by searching our members or check out upcoming events!")
//            } else {
//                tableView.restore()
//            }
//            return messages.count
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            if notifications.count == 0 {
//                tableView.setEmptyView(title: "You have no notifications", message: "")
//            } else {
//                tableView.restore()
//            }
//            return notifications.count
//        }
//        
//        return 0
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = UITableViewCell()
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageCell
//            if messages.count == 0 {
//                cell.textView.text = "You have no messages"
//            }
//            let message = messages[indexPath.row]
//            cell.message = message
//
//            cell.selectionStyle = .none
//            cell.accessoryType = .disclosureIndicator
//            cell.textView.isUserInteractionEnabled = false
//            cell.backgroundColor = UIColor.white
//            
//            return cell
//            
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            let cell2 = tableView.dequeueReusableCell(withIdentifier: notiCellId, for: indexPath) as! NotificationCell
//            
//            let notification = notifications[indexPath.row]
//            cell2.notification = notification
//            
//            cell2.selectionStyle = .none
//            cell2.accessoryType = .disclosureIndicator
//            cell2.backgroundColor = UIColor.white
//            
//            return cell2
//        }
//
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 75, y: cell.frame.height, width: cell.frame.width, height: 0.5)
//        bottomLine.backgroundColor = UIColor.lightGray.cgColor
//        cell.layer.addSublayer(bottomLine)
//
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 85
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            let message = messages[indexPath.row]
//            guard let chatPartnerId = message.chatPartnerId() else {
//                return
//            }
//            
//            let ref = Database.database().reference().child(Constants.Users).child(chatPartnerId)
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
////                guard let dictionary = snapshot.value as? [String: AnyObject] else {
////                    return
////                }
////                
////                let user = User(uid: chatPartnerId, dictionary: dictionary)
////                self.showChatVCforUser(user)
//                
//            }, withCancel: nil)
//            
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            guard let uid = Auth.auth().currentUser?.uid else {return}
//            let key = notifications[indexPath.row].key!
//            let ref = Database.database().reference().child("notifications").child(uid).child(key)
//            let userValues = [key: 0] as [String : Any]
//            let keyRef = Database.database().reference().child(Constants.Invoices).child(uid)
//            ref.observe(.value) { (snapshot) in
//                print(snapshot)
//                
//            }
//            keyRef.updateChildValues(userValues)
//        }
//        
//    }
//    
//    
//    func fetchUserAndSetupNavBarTitle() {
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        
//        Database.database().reference().child(Constants.Users).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            
////            if let dictionary = snapshot.value as? [String: AnyObject] {
////
////                let user = User(uid: uid, dictionary: dictionary)
////
////                self.setupNavBarWithUser(user)
////            }
//            
//        }, withCancel: nil)
//        
//        Database.database().reference().child(Constants.Chefs).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            
////            if let dictionary = snapshot.value as? [String: AnyObject] {
////                
////                let user = User(uid: uid, dictionary: dictionary)
////                
////                self.setupNavBarWithUser(user)
////            }
//            
//        }, withCancel: nil)
//    }
//    
//    func setupNavBarWithUser(_ user: User) {
//        
//        messages.removeAll()
//        messageDictionary.removeAll()
//        tableView.reloadData()
//        
//        observeUserMessages()
//        
//        let titleView = UIView()
//        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        
//        
//        let containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        titleView.addSubview(containerView)
//        
//        
//        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
//        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
//        
//        self.navigationItem.title = "Messages"
//        
//    }
//    
//}
//
//extension UITableView {
//    
//    func setEmptyView(title: String, message: String) {
//        
//        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
//        
//        let titleLabel = UILabel()
//        
//        let messageLabel = UILabel()
//        
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        titleLabel.textColor = UIColor.black
//        
//        titleLabel.font = UIFont.systemFont(ofSize: 18)
//        
//        messageLabel.textColor = UIColor.lightGray
//        
//        messageLabel.font = UIFont.systemFont(ofSize: 16)
//        
//        emptyView.addSubview(titleLabel)
//        
//        emptyView.addSubview(messageLabel)
//        
//        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
//        
//        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
//        
//        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
//        
//        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
//        
//        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
//        
//        titleLabel.text = title
//        
//        messageLabel.text = message
//        
//        messageLabel.numberOfLines = 0
//        
//        messageLabel.textAlignment = .center
//        
//        self.backgroundView = emptyView
//        
//        self.separatorStyle = .none
//        
//    }
//    
//    func restore() {
//        
//        self.backgroundView = nil
//        
//    }
//    
}




