//
//  SearchVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class SearchVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchControllerDelegate, SearchFilterDelegate {
    
    var uid = Auth.auth().currentUser?.uid

    let cellId = "cellId"
    let headerId = "headerId"
    
    var searchController : UISearchController!
    var collectionView: UICollectionView!
    
    var user: User?
    var review: Review?
    
    let formatter = DateFormatter()
    var getRatings: Double = 0.0
    var getLocation: String = ""
    var getCusine: String = ""
    var getDate: String = ""
    var getChefType: String = ""
    
    var blackoutDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        filterButton.isHidden = true
        handleSearch()
        fetchUsers()
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.backgroundColor = UIColor.mainGreen()
        searchBar.isHidden = false
    }
    
    //MARK: Views Setup
    
    fileprivate func setupNavTitle() {
        navigationItem.title = "Search Chefs"
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
        return button
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.black
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.black
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2
        return label
    }()
    
    let cusineLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.black
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.black
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2
        return label
    }()
    
    let chefTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.backgroundColor = UIColor.black
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = 2
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search by name, location or cusine..."
        search.barTintColor = UIColor.white
        search.searchBarStyle = .minimal
        search.setTextColor(color: UIColor.black)
        search.setTextFieldColor(color: UIColor.white)
        search.setPlaceholderTextColor(color: UIColor.lightGray)
        search.setSearchImageColor(color: UIColor.white)
        search.setTextFieldClearButtonColor(color: UIColor.white)
        search.delegate = self
        search.layer.cornerRadius = 2
        return search
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupViews() {
        view.addSubview(filterButton)
        filterButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 75, height: 25)
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: filterButton.leftAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 50)
        
        let stackView = UIStackView(arrangedSubviews: [ratingLabel, locationLabel, cusineLabel, dateLabel, chefTypeLabel])
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 0
        scrollView.addSubview(stackView)
        stackView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width, height: 75)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        
        self.view.addSubview(collectionView)
        collectionView.anchor(top: filterButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
//    var myBlackDates: Set<String> = []
    var myBlackoutDates = [String]()
    var filteredUsers = [User]()
    var users = [User]()
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child(Constants.Users)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                
                if key == Auth.auth().currentUser?.uid {return}
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                
                Database.database().reference().child(Constants.Ratings).child(key).observe( .value, with: { (snapshot) in
                    let count = snapshot.childrenCount
                    var total: Double = 0.0
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let val = snap.value as! Double
                        total += val
                    }
                    let average = total/Double(count)
                    user.ratings = average
                })
                //don't need dates here for chef search
                self.users.append(user)
                self.users.sort(by: { (u1, u2) -> Bool in
                    return u1.username.compare(u2.username) == .orderedAscending
                })
                
                self.filteredUsers = self.users
                self.collectionView?.reloadData()
            })
            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }
    }
    
    //MARK: Handle search and filter
    fileprivate func handleSearch() {
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "filter.png"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(handleFilter), for: UIControl.Event.touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        self.navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredUsers = self.users
        } else {
            filterUsersView(text: searchText)
        }
        filterButton.isHidden = true
        clearValues()
        self.collectionView?.reloadData()
        
    }
    
    func filterUsersView(text: String) {
        
        filteredUsers = self.users.filter { (user) -> Bool in
            user.username.lowercased().contains(text.lowercased()) || user.location.lowercased().contains(text.lowercased()) || user.cusine.lowercased().contains(text.lowercased())
        }
        self.collectionView?.reloadData()
    }
    
    func searchFilterController(_ searchFilterController: SearchFilterVC, didSaveSearch rating: Double, location: String, cusine: String, date: String, chefType: String) {
        
        getRatings = rating
        getLocation = location
        getCusine = cusine
        getDate = date
        getChefType = chefType
        
        filteredUsers = self.users.filter({ user -> Bool in
            print("user blackout \(user.availableDate)")
            return user.location.hasPrefix(location) && user.cusine.hasPrefix(cusine) && user.ratings >= rating && user.availableDate.contains(blackoutDate)
//            return user.location.hasPrefix(location) && user.cusine.hasPrefix(cusine) && user.chefType.hasPrefix(chefType) && user.ratings >= rating && user.availableDate.contains(blackoutDate)
        })

        
        collectionView.reloadData()
        setupFilterButtons()
    }

    func setupFilterButtons() {
        
        if getLocation.isEmpty {
            locationLabel.isHidden = true
        } else {
            locationLabel.text = "  Location: \(getLocation)  "
        }
        
        if getRatings.isEqual(to: 0.0) {
            ratingLabel.isHidden = true
        } else {
            ratingLabel.text = "  Rating: \(getRatings)  "
        }
        
        if getCusine.isEmpty {
            cusineLabel.isHidden = true
        } else {
            cusineLabel.text = "  Cusine: \(getCusine)  "
        }
        
        if getDate.isEmpty {
            dateLabel.isHidden = true
        } else {
            dateLabel.text = "  Date: \(getDate)  "
        }
        
        if getChefType.isEmpty {
            chefTypeLabel.isHidden = true
        } else {
            chefTypeLabel.text = "  \(getChefType) Chef  "
        }
        
        filterButton.isHidden = false
        filterButton.setTitle("Clear", for: .normal)
    }
    
    @objc func handleFilter() {
//        clearValues()
        let searchFilter = SearchFilterVC()
        searchFilter.delegate = self
        present(searchFilter, animated: true, completion: nil)
        collectionView.reloadData()
    }
    
    @objc func clearFilter() {
        filterButton.isHidden = true
        clearValues()
        filteredUsers = self.users
        collectionView.reloadData()
    }
    
    func clearValues() {
        locationLabel.text = nil
        ratingLabel.text = nil
        cusineLabel.text = nil
        dateLabel.text = nil
        chefTypeLabel.text = nil
    }
    
    //MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let user = filteredUsers[indexPath.row]
        
        let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileVC.userId = user.uid
        navigationController?.pushViewController(userProfileVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        
        cell.user = filteredUsers[indexPath.item]
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 75, y: cell.frame.height, width: cell.frame.width, height: 0.5)
        bottomLine.backgroundColor = UIColor.black.cgColor
        cell.layer.addSublayer(bottomLine)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    

}
