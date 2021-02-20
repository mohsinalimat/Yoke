//
//  MessageTableViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MessageTableViewController: UITableViewController {
    
    //MARK: - Properties
    let messageCell: String = "messageCell"
    var refresh: UIRefreshControl = UIRefreshControl()
    private var messages = [Message]()
    private var docReference: DocumentReference?
    let currentUserUid = Auth.auth().currentUser?.uid
    var user2UID: String?
    var user: User? {
        didSet {
            user2UID = user?.uid
        }
    }

    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        refreshViews()
        print("\(user2UID)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        fetchMessages()
    }
    
    //MARK: - Helper Functions
    func refreshViews() {
        refresh.attributedTitle = NSAttributedString(string: "Pull see update")
        refresh.addTarget(self, action: #selector(updateViews), for: .valueChanged)
        tableView?.addSubview(refresh)
    }
    
    @objc func updateViews() {
        fetchMessages()
        messages.removeAll()
    }
    
    func registerTableViewCell() {
        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCell)
    }

    func setupViews() {
        tableView.backgroundColor = .white
        navigationItem.title = "Messages"
        view.addSubview(noMessageLabel)
    }

    private func fetchMessages() {
        let db = Firestore.firestore().collection(Constants.Messages)
            .whereField(Constants.Users, arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        db.getDocuments() { (snapshot, error) in
            for doc in snapshot!.documents {
                self.docReference = doc.reference
                doc.reference.collection(Constants.Thread)
                    .order(by: Constants.Created, descending: true).limit(to: 1).getDocuments() {
                        (snapshot, error) in
                        guard let snap = snapshot else { return }
                        if let doc = snap.documents.first {
                            guard let messageToAppend = Message(dictionary: doc.data()) else { return }
                            print("message \(messageToAppend)")
                            self.messages.append(messageToAppend)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            self.refresh.endRefreshing()
                        }
                }
            }
        }
    }

    //MARK: - Views
    private let noMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "No Messages"
        label.textAlignment = .center
        label.textColor = UIColor.orangeColor()
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages.count)
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: messageCell, for: indexPath) as? MessageCell else { return UITableViewCell() }
        let message = messages[indexPath.row]
        cell.message = message
        cell.backgroundColor = .white
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = ChatViewController()
        let uid = messages[indexPath.row].toId
        let currentUid = messages[indexPath.row].senderID
        if currentUserUid == uid {
            chatVC.user2UID = currentUid
            navigationController?.pushViewController(chatVC, animated: true)
        } else {
            chatVC.user2UID = uid
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

