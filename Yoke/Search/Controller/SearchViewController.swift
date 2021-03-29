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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavigationBar()
        fetchUsers()
        setupTableView()
        setupSearch()
        dismissKeyboardOnTap()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Search", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
        let filterIcon = UIImage(named: "filterOrange")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.image = filterIcon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(handleShowFilter))
    }
    
    func setupTableView() {
        tableView.backgroundColor = UIColor.LightGrayBg()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupSearch() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.view.setNeedsLayout()
        navigationController?.view.layoutIfNeeded()

        guard let orange = UIColor.orangeColor() else { return }
        searchController.searchBar.tintColor = orange
        searchController.searchBar.barTintColor = orange
        searchController.searchBar.setImage(UIImage(named: "searchOrange"), for: UISearchBar.Icon.search, state: .normal)
        searchController.searchBar.setImage(UIImage(named: "clearOrangeFill"), for: UISearchBar.Icon.clear, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: orange]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search by name or location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        searchController.searchBar.becomeFirstResponder()
    }
    
    //MARK: - API
    func fetchUsers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserController.shared.fetchUsers(uid: uid) { (result) in
            switch result {
            default:
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
        let user = UserController.shared.filteredUsers[indexPath.row].uid
        let userProfileVC = ProfileViewController()
        userProfileVC.userId = user
        navigationController?.pushViewController(userProfileVC, animated: true)
    }
    
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

