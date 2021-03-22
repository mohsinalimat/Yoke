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
    private let tableView = UITableView()
    private var conversations = [Conversation]()
    private var conversationDictionary = [String: Conversation]()
    let cellId = "cellId"
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
//        addBackgroundGradient()
        view.addSubview(tableView)
    }
    
    func constrainViews() {
        tableView.frame = view.frame

    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Messages", largeTitle: true, backgroundColor: .white, titleColor: orange)
    }
    
    func configureTableView() {
        tableView.backgroundColor = UIColor.LightGrayBg()
        tableView.rowHeight = 80
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    //MARK: - API
    func fetchConversations() {
        ConversationController.shared.fetchConversations { (conversations) in
            conversations.forEach { (conversation) in
                let message = conversation.message
                self.conversationDictionary[message.chatPartnerId] = conversation
            }
            self.conversations = Array(self.conversationDictionary.values)
            self.tableView.reloadData()
        }
    }
}
//MARK: - TableView DataSource
extension MessageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageTableViewCell
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
            let conversation = conversations[indexPath.row]
            guard let indexOfConversation = conversations.firstIndex(of: conversation) else { return }
            ConversationController.shared.deleteConversation(currentUserUid: conversation.message.toId, userUid: conversation.message.fromId) { (result) in
                switch result {
                case true:
                    self.conversations.remove(at: indexOfConversation)
                    DispatchQueue.main.async {
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                case false:
                    print(false)
                }
            }
        }
    }
}

//MARK: - TableView Delegate
extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].message.chatPartnerId
        let chatVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.userId = user
        navigationController?.pushViewController(chatVC, animated: true)
    }

}
