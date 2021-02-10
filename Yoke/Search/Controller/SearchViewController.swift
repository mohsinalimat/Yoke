//
//  SearchViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/9/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class SearchViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let tableView = UITableView()
    var searchController = UISearchController()
    var users = [User]()
    var filteredUsers = [User]()
    let firestoreDB = Firestore.firestore()
    var getLocation: String = ""
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
//        setupSearch()
        setupNavigationAndBarButtons()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        tableView.backgroundColor = .white
        navigationItem.title = "Search"
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    func constrainViews() {
        searchBar.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 45)
        tableView.anchor(top: searchBar.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)

    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupNavigationAndBarButtons() {
        navigationItem.title = "Search"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowFilter))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClear))
    }
    
    @objc func handleClear() {
        filteredUsers = self.users
        tableView.reloadData()
    }
    
    @objc func handleShowFilter() {
//        let filterVC = UserFilterViewController()
//        filterVC.delegate = self
//        let rootVC = UINavigationController(rootViewController: filterVC)
//        present(rootVC, animated: true)
    }
    
    func fetchUsers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserController.shared.fetchUsers(uid: uid) { (result) in
            switch result {
            default:
                print("fetched")
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Views
    var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search by name or location"
        search.searchTextField.textColor = UIColor.orangeColor()
        search.searchTextField.backgroundColor = UIColor.white
        search.tintColor = UIColor.orangeColor()
        search.backgroundColor = UIColor.orangeColor()
        search.barTintColor = UIColor.orangeColor()
        return search
    }()
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let user = UserController.shared.users[indexPath.row]
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let user = users[indexPath.row]
//        let userProfileVC = UserProfileViewController()
//        userProfileVC.userId = user.uid
//        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = self.users.filter { (user) -> Bool in
                guard let username = user.username,
                      let location = user.location else { return false }
                return username.lowercased().contains(searchText.lowercased()) || location.lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupSearch() {
        searchBar.delegate = self
    }
}

//extension SearchUsersViewController: SearchUsersFilterDelegate {
//    func searchFilterController(_ searchFilterController: UserFilterViewController, didSaveSearch location: String, activies: String) {
//        filteredUsers = self.users.filter({ user -> Bool in
//            guard let result = user.location?.hasPrefix(location) else { return false }
//            return result
//        })
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//}
