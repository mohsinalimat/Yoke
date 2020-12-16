//
//  AddUserVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class AddUserVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchControllerDelegate {

    let cellId = "cellId"
    let searchCellId = "searchCellId"
    var uid = Auth.auth().currentUser?.uid

    var user: User?

    var filteredUsers = [User]()
    var filterSearch = [User]()
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = .white
        collectionView?.keyboardDismissMode = .onDrag
        self.collectionView!.register(AddBookmarkedUserCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true

        fetchUsers()
        fetchAllSaved()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    fileprivate func fetchAllSaved() {
        users.removeAll()
        fetchBookmarkedUserIds()
    }
    
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["All Users","Saved Users"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = UIColor.orangeColor()
        seg.tintColor = UIColor.white
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        seg.addTarget(self, action: #selector(getSegments), for: .valueChanged)
        return seg
    }()
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    @objc func getSegments(index: Int) {
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView?.reloadData()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            collectionView?.reloadData()
        }
    }
    
    func setupViews() {
        navigationItem.title = "Add User"
        self.searchController = UISearchController(searchResultsController:  nil)
        let rightButton = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(handleNext))
        navigationItem.rightBarButtonItem = rightButton
        view.addSubview(searchBar)
        searchBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(headerView)
        headerView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop:0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 35)
        
        view.addSubview(segmentedControl)
        segmentedControl.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        collectionView!.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)

    }
    
    @objc func handleNext() {
        let addEvent = NewScheduleEventVC()
        navigationController?.pushViewController(addEvent, animated: true)
    }
    
    var users = [User]()
    fileprivate func fetchBookmarkedUserIds() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchUsers(user: user)
        }
    }
    
    fileprivate func fetchUsers(user: User) {
        
        if #available(iOS 10.0, *) {
            self.collectionView?.refreshControl?.endRefreshing()
        } else {
            // Fallback on earlier versions
        }
        
        let ref = Database.database().reference().child(Constants.Users)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
                guard let userDictionary = value as? [String: Any] else { return }
//                Database.database().reference().child(Constants.BookmarkedUsers).child(self.uid!).child(key).observeSingleEvent(of: .value, with: { (snapshot) in
//                    
//                    let user = User(uid: key, dictionary: userDictionary)
//                    
//                    if let value = snapshot.value as? Int, value == 1 {
//                        user.isSaved = true
//                        self.users.append(user)
//                        self.users.sort(by: { (u1, u2) -> Bool in
//                            return u1.username.compare(u2.username) == .orderedAscending
//                        })
//                    } else {
//                        user.isSaved = false
//                    }
//                    self.filterSearch = self.users
//                    self.collectionView?.reloadData()
//                })
                
            })
            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }
        
    }
    
    var searchUsers = [User]()
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child(Constants.Users)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let dictionaries = snapshot.value as? [String: Any] else { return }
//            
//            dictionaries.forEach({ (key, value) in
//                
//                if key == Auth.auth().currentUser?.uid {
//                    return
//                }
//                
//                guard let userDictionary = value as? [String: Any] else { return }
//                
//                let user = User(uid: key, dictionary: userDictionary)
//                
//                self.searchUsers.append(user)
//            })
//            
//            self.searchUsers.sort(by: { (u1, u2) -> Bool in
//                return u1.username.compare(u2.username) == .orderedAscending
//            })
//            
//            self.filteredUsers = self.searchUsers
//            self.collectionView?.reloadData()
//            
//        }) { (err) in
//            print("Failed to fetch users for search:", err)
//        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = self.searchUsers
            filterSearch = self.users
        } else {
            filterUsersView(index: searchBar.selectedScopeButtonIndex, text: searchText)
            
        }
        
        print("there are no users based on your search")
        
        self.collectionView?.reloadData()
        
    }
    
    func filterUsersView(index: Int, text: String) {
//        filteredUsers = self.searchUsers.filter { (user) -> Bool in
//            return user.username?.lowercased().contains(text.lowercased())
//        }
//        filterSearch = self.users.filter { (user) -> Bool in
//            return user.username?.lowercased().contains(text.lowercased())
//        }
        
        self.collectionView?.reloadData()
    }
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search by name"
        search.backgroundColor = UIColor.orangeColor()
        search.barTintColor = UIColor.black
        search.searchBarStyle = .minimal
        search.setTextColor(color: UIColor.black)
        search.setTextFieldColor(color: UIColor.white)
        search.setPlaceholderTextColor(color: UIColor.lightGray)
        search.setSearchImageColor(color: UIColor.black)
        search.setTextFieldClearButtonColor(color: UIColor.black)
        search.delegate = self
        search.layer.cornerRadius = 2
        return search
    }()
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return filteredUsers.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return filterSearch.count
        }
        
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddBookmarkedUserCell
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.user = filteredUsers[indexPath.item]
            return cell
        }
        cell.user = filterSearch[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        if segmentedControl.selectedSegmentIndex == 0 {
            let user = filteredUsers[indexPath.row]
            let addCalenddarEventVC = NewScheduleEventVC()
            addCalenddarEventVC.userId = user.uid
            navigationController?.pushViewController(addCalenddarEventVC, animated: true)
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let user = filterSearch[indexPath.row]
            let addCalenddarEventVC = NewScheduleEventVC()
            addCalenddarEventVC.userId = user.uid
            navigationController?.pushViewController(addCalenddarEventVC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }

}
