//
//  ConversationsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/20/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class ConversationsViewController: UIViewController {

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
        configureNav()
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
    
    func configureNav() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor.orangeColor()
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func configureTableView() {
        tableView.backgroundColor = UIColor.LightGrayBg()
        tableView.rowHeight = 80
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    private func addBackgroundGradient() {
        let collectionViewBackgroundView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view.frame.size
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor.orangeColor()?.withAlphaComponent(0.5).cgColor ?? "", UIColor.yellowColor()?.withAlphaComponent(0.2).cgColor ?? ""]
        tableView.backgroundView = collectionViewBackgroundView
        tableView.backgroundView?.layer.addSublayer(gradientLayer)
    }
    
    func gradient(frame:CGRect) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.colors = [UIColor.orangeColor()?.cgColor ?? "", UIColor.yellowColor()?.cgColor ?? ""]
        return layer
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
extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationTableViewCell
        cell.conversation = conversations[indexPath.row]
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.cellBackgroundView.layer.insertSublayer(gradient(frame: cell.bounds), at:0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
extension ConversationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].message.chatPartnerId
        let chatVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.userId = user
        navigationController?.pushViewController(chatVC, animated: true)
    }

}
