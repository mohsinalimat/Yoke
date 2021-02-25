//
//  ChatCollectionViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "Cell"

class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK: - Properties
    var userId: String?
    var user: User?

    
    //MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
//        configureNav()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        fetchUser()
    }
    
    override var inputAccessoryView: UIView? {
        get { return chatInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    //MARK: - Helper Functions
    func setupViews() {
        collectionView.backgroundColor = .white
    }
    
    func setupCollectionView() {
        
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
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            guard let username = user.username else { return }
            self.navigationItem.title = username
        }
    }
    

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate


    //MARK: - Views
    private lazy var chatInputView: ChatInputAccessoryView = {
        let customView = ChatInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        return customView
    }()
}
