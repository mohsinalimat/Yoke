//
//  ChatCollectionViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK: - Properties
    let cellId = "cellId"
    var userId: String?
    var user: User?
    private var messages = [Message]()
    var fromCurrentUser = false

    
    //MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        fetchUser()
        fetchMessages()
    }
    
    override var inputAccessoryView: UIView? {
        get { return chatInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }


    //MARK: - Helper Functions
    func setupViews() {
        addBackgroundGradient()
    }
    
    func setupCollectionView() {
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.clipsToBounds = true
        collectionView.keyboardDismissMode = .interactive
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
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
    
    private func addBackgroundGradient() {
        let collectionViewBackgroundView = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view.frame.size
        // Start and end for left to right gradient
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = [UIColor.yellowColor()?.cgColor, UIColor.orangeColor()?.cgColor]
        collectionView.backgroundView = collectionViewBackgroundView
        collectionView.backgroundView?.layer.addSublayer(gradientLayer)
      }
    
    //MARK: - API
    func fetchMessages() {
        guard let userId = userId else { return }
        ConversationController.shared.fetchMessages(forUser: userId) { (messages) in
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }
    }
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username else { return }
            self.navigationItem.title = username
        }
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
        cell.message = messages[indexPath.row]
        guard let uid = userId else { return UICollectionViewCell()}
        cell.setupProfileImage(uid: uid)
        return cell
    }

    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = ChatCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        return CGSize(width: view.frame.width, height: estimatedSize.height)
//        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }

    //MARK: - Views
    private lazy var chatInputView: ChatInputAccessoryView = {
        let customView = ChatInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        customView.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(0.8)
        customView.delegate = self
        return customView
    }()
}

extension ChatCollectionViewController: ChatInputAccessoryViewDelegate {
    func inputView(_ inputView: ChatInputAccessoryView, wantsToSend message: String) {
        guard let userId = userId else { return }
        ConversationController.shared.uploadMessage(message, to: userId) { (error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
                return
            }
            inputView.clearText()
        }
    }
}
