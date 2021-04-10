//
//  MessageViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/20/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    private let messageTableView = UITableView()
    private let requestTableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationDictionary = [String: Conversation]()
    let cellId = "cellId"
    let cellId2 = "cellId2"
    var userId: String?
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchConversations()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(segmentedControl)
        view.addSubview(messageTableView)
        view.addSubview(requestTableView)
    }
    
    func constrainViews() {
        segmentedControl.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
        messageTableView.anchor(top: segmentedControl.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        requestTableView.anchor(top: segmentedControl.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)

    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Messages", largeTitle: true, backgroundColor: .white, titleColor: orange)
    }
    
    func configureTableView() {
        messageTableView.backgroundColor = UIColor.LightGrayBg()
        messageTableView.rowHeight = 80
        messageTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
        messageTableView.tableFooterView = UIView()
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.separatorStyle = .none
        messageTableView.isHidden = false
        
        requestTableView.backgroundColor = UIColor.LightGrayBg()
        requestTableView.rowHeight = 80
        requestTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId2)
        requestTableView.tableFooterView = UIView()
        requestTableView.delegate = self
        requestTableView.dataSource = self
        requestTableView.separatorStyle = .none
        requestTableView.isHidden = true
    }
    
    //MARK: - API
    func fetchConversations() {
        ConversationController.shared.fetchConversations { (conversations) in
            conversations.forEach { (conversation) in
                let message = conversation.message
                self.conversationDictionary[message.chatPartnerId] = conversation
            }
            self.conversations = Array(self.conversationDictionary.values)
            self.messageTableView.reloadData()
        }
    }
    
    //MARK: - Selectors
    @objc func handleSegSelection(index: Int) {
        if segmentedControl.selectedSegmentIndex == 0 {
            requestTableView.isHidden = true
            messageTableView.isHidden = false
        } else if segmentedControl.selectedSegmentIndex == 1 {
            messageTableView.isHidden = true
            requestTableView.isHidden = false
        }
    }
    
    //MARK: - Views
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Messages", "Request"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = UIColor.orangeColor()
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orangeColor()!], for: UIControl.State.selected)
        seg.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        seg.addTarget(self, action: #selector(handleSegSelection), for: .valueChanged)
        return seg
    }()
}
//MARK: - TableView DataSource
extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == messageTableView {
            return conversations.count
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == messageTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageTableViewCell
            cell.conversation = conversations[indexPath.row]
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.LightGrayBg()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! MessageTableViewCell
        cell.conversation = conversations[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.LightGrayBg()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == messageTableView {
                let conversation = conversations[indexPath.row]
                guard let indexOfConversation = conversations.firstIndex(of: conversation) else { return }
                ConversationController.shared.deleteConversation(currentUserUid: conversation.message.toId, userUid: conversation.message.fromId) { (result) in
                    switch result {
                    case true:
                        self.conversations.remove(at: indexOfConversation)
                        DispatchQueue.main.async {
                            self.messageTableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    case false:
                        print(false)
                    }
                }
            }
        }
    }
}

//MARK: - TableView Delegate
extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == messageTableView {
            let user = conversations[indexPath.row].message.chatPartnerId
            let chatVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            chatVC.userId = user
            navigationController?.pushViewController(chatVC, animated: true)
        }
    }

}
