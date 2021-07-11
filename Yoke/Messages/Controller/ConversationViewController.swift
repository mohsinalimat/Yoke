//
//  ConversationViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/20/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConversationViewController: UIViewController {

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
        fetchBookings()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(segmentShadowView)
        view.addSubview(segmentedControl)
        view.addSubview(messageTableView)
        view.addSubview(requestTableView)
    }
    
    func constrainViews() {
        segmentShadowView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 45)
        segmentedControl.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 45)
        messageTableView.anchor(top: segmentedControl.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        requestTableView.anchor(top: segmentedControl.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)

    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Messages", largeTitle: true, backgroundColor: .white, titleColor: orange)
        let archiveIcon = UIImage(named: "archive")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.image = archiveIcon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: archiveIcon, style: .plain, target: self, action: #selector(handleArchive))
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
        requestTableView.register(RequestTableViewCell.self, forCellReuseIdentifier: cellId2)
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
            DispatchQueue.main.async {
                self.messageTableView.reloadData()
            }
        }
    }
    
    func fetchBookings() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
        BookingController.shared.fetchBookingsWith(uid: currentUserUid) { (result) in
            switch result {
            default:
                DispatchQueue.main.async {
                    self.requestTableView.reloadData()
                }
                
            }
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
    
    @objc func handleArchive() {
        let archiveVC = BookingArchiveTableViewController()
        navigationController?.pushViewController(archiveVC, animated: true)
    }
    
    //MARK: - Views
    let segmentShadowView: ShadowView = {
        let view = ShadowView()
        return view
    }()
    
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Messages", "Request"])
        seg.selectedSegmentIndex = 0
        seg.layer.cornerRadius = 10
        seg.layer.borderWidth = 0.5
        seg.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        let image = UIImage(named: "whiteBG")
        seg.setBackgroundImage(image, for: .normal, barMetrics: .default)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orangeColor()!], for: UIControl.State.selected)
        seg.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)], for: UIControl.State.normal)
        seg.addTarget(self, action: #selector(handleSegSelection), for: .valueChanged)
        return seg
    }()
}

//MARK: - TableView DataSource
extension ConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == messageTableView {
            return conversations.count
        }
        return BookingController.shared.bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == messageTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessageTableViewCell
            cell.conversation = conversations[indexPath.row]
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.LightGrayBg()
            return cell
        }
        let cell2 = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! RequestTableViewCell
        cell2.booking = BookingController.shared.bookings[indexPath.row]
        cell2.selectionStyle = .none
        cell2.backgroundColor = UIColor.LightGrayBg()
        return cell2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == messageTableView {
            return 110
        }
        return 200
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            guard let currentUserUid = Auth.auth().currentUser?.uid else { return }
            ConversationController.shared.deleteConversation(uid: currentUserUid) { result in
                switch result {
                default:
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                }
            }
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

//MARK: - TableView Delegate
extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == messageTableView {
            let user = conversations[indexPath.row].message.chatPartnerId
            let chatVC = ChatCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
            chatVC.userId = user
            navigationController?.pushViewController(chatVC, animated: true)
        }
        if tableView == requestTableView {
            let request = BookingController.shared.bookings[indexPath.row]
            if request.invoiceSent == true {
                let requestVC = MakePaymentViewController()
                requestVC.booking = request
                navigationController?.pushViewController(requestVC, animated: true)
            } else {
                let requestVC = BookingRequestDetailViewController()
                requestVC.booking = request
                navigationController?.pushViewController(requestVC, animated: true)
            }
        }
    }

}
