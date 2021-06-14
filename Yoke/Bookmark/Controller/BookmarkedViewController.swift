//
//  BookmarkedViewController.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class BookmarkedViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    private let userTableView = UITableView()
    private let eventTableView = UITableView()
    var uid = Auth.auth().currentUser?.uid
    let cellId = "cellId"
    let cellId2 = "cellId2"

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
        fetchEvents()
        fetchUsers()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(segmentShadowView)
        view.addSubview(segmentedControl)
        view.addSubview(userTableView)
        view.addSubview(eventTableView)
    }
    
    func constrainViews() {
        segmentShadowView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 45)
        segmentedControl.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 45)
        userTableView.anchor(top: segmentedControl.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        eventTableView.anchor(top: segmentedControl.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func configureTableView() {
        userTableView.backgroundColor = UIColor.LightGrayBg()
        userTableView.rowHeight = 80
        userTableView.register(BookmarkedUsersTableViewCell.self, forCellReuseIdentifier: cellId)
        userTableView.tableFooterView = UIView()
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.separatorStyle = .none
        userTableView.isHidden = false
        
        eventTableView.backgroundColor = UIColor.LightGrayBg()
        eventTableView.rowHeight = 80
        eventTableView.register(BookmakredEventsTableViewCell.self, forCellReuseIdentifier: cellId2)
        eventTableView.tableFooterView = UIView()
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.separatorStyle = .none
        eventTableView.isHidden = true
    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Bookmarks", largeTitle: true, backgroundColor: .white, titleColor: orange)
    }
    
    //MARK: - API
    func fetchUsers() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        BookmarkController.shared.fetchBookmarkedUserWith(uid: currentUserId) { result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.userTableView.reloadData()
                }
            case false:
                print("false")
            }
        }
    }

    func fetchEvents() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        BookmarkController.shared.fetchBookmarkedEventWith(uid: currentUserId) { result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.eventTableView.reloadData()
                }
            case false:
                print("false")
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleSegSelection(index: Int) {
        if segmentedControl.selectedSegmentIndex == 0 {
            userTableView.isHidden = false
            eventTableView.isHidden = true
        } else if segmentedControl.selectedSegmentIndex == 1 {
            userTableView.isHidden = true
            eventTableView.isHidden = false
        }
    }
    
//    @objc func getSegments(index: Int) {
//        if segmentedControl.selectedSegmentIndex == 0 {
//            userTableView.reloadData()
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            eventTableView.reloadData()
//        }
//    }
    
    //MARK: - Views
    let segmentShadowView: ShadowView = {
        let view = ShadowView()
        return view
    }()
    
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Users","Events"])
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
extension BookmarkedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == userTableView {
            return BookmarkController.shared.users.count
        }
        return BookmarkController.shared.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == userTableView {
            let cellA = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! BookmarkedUsersTableViewCell
            cellA.user = BookmarkController.shared.users[indexPath.row]
            cellA.backgroundColor = UIColor.LightGrayBg()
            return cellA
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! BookmakredEventsTableViewCell
        cell.event = BookmarkController.shared.events[indexPath.row]
        cell.backgroundColor = UIColor.LightGrayBg()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == eventTableView {
            return 150
        }
        return 100
    }
}

//MARK: - TableView Delegate
extension BookmarkedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
