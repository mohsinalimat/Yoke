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

class SearchViewController: UITableViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
//    let tableView = UITableView()
    var searchController = UISearchController()
    let firestoreDB = Firestore.firestore()
    var getLocation: String = ""
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
//        constrainViews()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        setupSearch()
        dismissKeyboardOnTap()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
//        view.backgroundColor = UIColor.LightGrayBg()
        tableView.backgroundColor = UIColor.LightGrayBg()
        
    }
    
//    func constrainViews() {
//        tableView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
//    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Search", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowFilter))
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupSearch() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        
        guard let orange = UIColor.orangeColor() else { return }
        searchController.searchBar.tintColor = orange
        searchController.searchBar.barTintColor = orange
        searchController.searchBar.setImage(UIImage(named: "searchOrange"), for: UISearchBar.Icon.search, state: .normal)
        searchController.searchBar.setImage(UIImage(named: "clearOrangeFill"), for: UISearchBar.Icon.clear, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: orange]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search by name or location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        searchController.searchBar.becomeFirstResponder()
        
        navigationItem.titleView = searchController.searchBar
    }
    
    //MARK: - API
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
    
    //MARK: - Selectors
    @objc func handleShowFilter() {
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserController.shared.filteredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let user = UserController.shared.filteredUsers[indexPath.row]
        cell.backgroundColor = UIColor.LightGrayBg()
        cell.selectionStyle = .none
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = UserController.shared.filteredUsers[indexPath.row]
        print(user.username)
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected")
////        let user = UserController.shared.filteredUsers[indexPath.row]
////        let userProfileVC = ProfileViewController()
////        userProfileVC.userId = user.uid
////        navigationController?.pushViewController(userProfileVC, animated: true)
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        print(searchText)
        if searchText.isEmpty {
            UserController.shared.filteredUsers = UserController.shared.users
        } else {
            UserController.shared.filteredUsers = UserController.shared.users.filter { (user) -> Bool in
                guard let username = user.username,
                      let location = user.location else { return false }
                return username.lowercased().contains(searchText.lowercased()) || location.lowercased().contains(searchText.lowercased())
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return UserController.shared.filteredUsers.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
//        let user = UserController.shared.filteredUsers[indexPath.row]
//        cell.backgroundColor = UIColor.LightGrayBg()
//        cell.selectionStyle = .none
//        cell.user = user
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected")
//        let user = UserController.shared.filteredUsers[indexPath.row]
//        let userProfileVC = ProfileViewController()
//        userProfileVC.userId = user.uid
//        navigationController?.pushViewController(userProfileVC, animated: true)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
//}

