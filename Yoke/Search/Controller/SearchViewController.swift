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
    let firestoreDB = Firestore.firestore()
    var getLocation: String = ""
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
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
        setupNavigationAndBarButtons()
        dismissKeyboardOnTap()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        tableView.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }
    
    func constrainViews() {
        searchBar.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 45)
        tableView.anchor(top: searchBar.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)

    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Search", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
    
    func setupNavigationAndBarButtons() {
        navigationItem.title = "Search"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleShowFilter))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClear))
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
    @objc func handleClear() {
        UserController.shared.filteredUsers = UserController.shared.users
        tableView.reloadData()
    }
    
    @objc func handleShowFilter() {
//        let filterVC = UserFilterViewController()
//        filterVC.delegate = self
//        let rootVC = UINavigationController(rootViewController: filterVC)
//        present(rootVC, animated: true)
    }
    
    //MARK: - Views
    var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search by name or location"
        search.searchTextField.textColor = UIColor.white
        search.searchTextField.backgroundColor = UIColor.white
        search.tintColor = UIColor.white
        search.backgroundColor = UIColor.white
        search.barTintColor = UIColor.white
        return search
    }()
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("search count \(UserController.shared.filteredUsers.count)")
        return UserController.shared.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        let user = UserController.shared.filteredUsers[indexPath.row]
        cell.backgroundColor = UIColor.LightGrayBg()
        cell.selectionStyle = .none
        cell.user = user
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = UserController.shared.filteredUsers[indexPath.row]
        let userProfileVC = ProfileViewController()
        userProfileVC.userId = user.uid
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
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
