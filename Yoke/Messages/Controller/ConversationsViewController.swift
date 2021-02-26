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
    let cellId = "cellId"
    var userId: String?
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNav()
        fetchConversations()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        addBackgroundGradient()
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addBackgroundGradient() {
        let collectionViewBackgroundView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view.frame.size
        // Start and end for left to right gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor.orangeColor()?.cgColor, UIColor.yellowColor()?.cgColor]
        tableView.backgroundView = collectionViewBackgroundView
        tableView.backgroundView?.layer.addSublayer(gradientLayer)
      }
    
    //MARK: - API
    func fetchConversations() {
        ConversationController.shared.fetchConversations { (conversations) in
            self.conversations = conversations
            self.tableView.reloadData()
        }
    }
}

extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row].message.text
        cell.textLabel?.textColor = .darkGray
        cell.backgroundColor = .white
        return cell
    }
}

extension ConversationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
