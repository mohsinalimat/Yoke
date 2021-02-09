//
//  CreateInvoiceVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 5/6/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class CreateInvoiceVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchControllerDelegate, UITextViewDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var collectionView: UICollectionView!
    var uid = Auth.auth().currentUser?.uid
    var selectedUser: String = ""
    var filteredUsers = [User]()
    var filterSearch = [User]()
    let cellId = "cellId"
    var searchController : UISearchController!
    var tapGesture = UITapGestureRecognizer()
    var user: User?
    var gallery: Gallery?
    
    fileprivate func fetchSelectedUser() {
//        selectedUser = (gallery?.bookmarkedUser)!
//        let uid = selectedUser
//        
//        Database.fetchUserWithUID(uid: uid) { (user) in
//            self.user = user
//            self.addUserLabel.text = user.username
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        setupCollectionView()
        setupPickerViews()
        fetchUsers()
        fetchAllSaved()
        validForm()
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(CreateInvoiceVC.myviewTapped(_:)))
        addUserLabel.addGestureRecognizer(tapGesture)
        addUserLabel.isUserInteractionEnabled = true

        
    }

    func setupPickerViews() {
        datePickerView()
        startTimePickerView()
        endTimePickerView()
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Payment Request"
    }
        
    let addUserLabel: UITextField = {
        let label = UITextField()
        label.text = "* Send invoice to:"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return label
    }()
        
    let requiredLabel: UILabel = {
        let label = UILabel()
        label.text = "* required"
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
        
    var addUserButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "add_image"), for: .normal)
        button.addTarget(self, action: #selector(getUsers), for: .touchUpInside)
        return button
    }()
        
    var referenceField: UITextField = {
        let textView = UITextField()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textColor = UIColor.darkGray
        textView.layer.cornerRadius = 5
        textView.attributedPlaceholder =
                NSAttributedString(string: "* Reference Title", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textView.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return textView
    }()
        
    let descriptionField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textColor = UIColor.darkGray
        textView.layer.cornerRadius = 5
        textView.placeholder = "Enter details here..."
        return textView
    }()
        
    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "* Invoice Total $"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
        
    var amountField: CurrencyField = {
        let textView = CurrencyField()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textColor = UIColor.darkGray
        textView.layer.cornerRadius = 5
        textView.keyboardType = .numberPad
        textView.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return textView
    }()
        
    let photoImageView1: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let photoImageView2: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let photoImageView3: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let photoImageView4: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
        
    let addPhotoButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.setTitle("Add Photo", for: .normal)
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 2
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePhotoButton1), for: .touchUpInside)
        return button
    }()
    
    let addPhotoButton2: UIButton = {
            let button = UIButton(type: .custom)
    //        button.setTitle("Add Photo", for: .normal)
            button.setImage(UIImage(named: "camera"), for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.cornerRadius = 2
            button.backgroundColor = UIColor.orangeColor()
            button.layer.cornerRadius = 5
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(handlePhotoButton2), for: .touchUpInside)
            return button
        }()
    
    let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "Attach an image such as a recipt or anythig that might be needed for this invoice"
        label.textColor = UIColor.darkGray
        label.textAlignment = .left
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
        
    var sendInvoiceButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Send Payment Request", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(0.8)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    
    
    func setupViews() {
        view.addSubview(self.scrollView)
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        self.scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(addUserLabel)
        addUserLabel.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        scrollView.addSubview(addUserButton)
        addUserButton.anchor(top: addUserLabel.topAnchor, left: addUserLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
        scrollView.addSubview(dateImageView)
        dateImageView.anchor(top: addUserLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        scrollView.addSubview(dateView)
        dateView.anchor(top: dateImageView.topAnchor, left: dateImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 30)
        
        scrollView.addSubview(dateField)
        dateField.anchor(top: dateView.topAnchor, left: dateView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 110, height: 30)
        
        
        scrollView.addSubview(timeImageView)
        timeImageView.anchor(top: dateImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        scrollView.addSubview(startView)
        startView.anchor(top: timeImageView.topAnchor, left: timeImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 130, height: 30)
        
        scrollView.addSubview(endView)
        endView.anchor(top: timeImageView.topAnchor, left: startView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 130, height: 30)
        
        scrollView.addSubview(referenceField)
        referenceField.anchor(top: endView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 31)
        
        scrollView.addSubview(descriptionField)
        descriptionField.anchor(top: referenceField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 150)

        scrollView.addSubview(amountLabel)
        amountLabel.anchor(top: descriptionField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 150, height: 31)
        
        scrollView.addSubview(amountField)
        amountField.anchor(top: descriptionField.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 150, height: 31)
        
        scrollView.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: amountField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 50, height: 50)
//        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        scrollView.addSubview(addPhotoButton2)
        addPhotoButton2.anchor(top: amountField.bottomAnchor, left: addPhotoButton.rightAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 50, height: 50)
        
//        scrollView.addSubview(photoImageView)
        let stackView = UIStackView(arrangedSubviews: [photoImageView1, photoImageView2, photoImageView3, photoImageView4])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        view.addSubview(stackView)
        stackView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 75)
//        photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        scrollView.addSubview(sendInvoiceButton)
        sendInvoiceButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)
        
        scrollView.addSubview(requiredLabel)
        requiredLabel.anchor(top: sendInvoiceButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setupNavTitleAndBarButtonItems()
    }
    
    
    //MARK: CollectionView
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TagUsertoPhotoCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.alwaysBounceVertical = true
        self.collectionView.alpha = 0
        
        view.addSubview(collectionView)
        collectionView.anchor(top: addUserLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        
        collectionView.addSubview(segmentedControl)
        segmentedControl.anchor(top: collectionView.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
        
        collectionView.addSubview(searchBar)
        searchBar.anchor(top: segmentedControl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search by name"
        search.backgroundColor = UIColor.white
        search.barTintColor = UIColor.black
        search.searchBarStyle = .minimal
        search.setTextColor(color: UIColor.black)
        search.setTextFieldColor(color: UIColor.white)
        search.setPlaceholderTextColor(color: UIColor.lightGray)
        search.setSearchImageColor(color: UIColor.black)
        search.setTextFieldClearButtonColor(color: UIColor.black)
        search.delegate = self
        search.layer.cornerRadius = 2
//        search.isHidden = true
        return search
    }()
    
    var segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["All Users","Saved Users"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = UIColor.orangeColor()
        seg.tintColor = UIColor.white
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
//        seg.isHidden = true
        seg.addTarget(self, action: #selector(getSegments), for: .valueChanged)
        return seg
    }()
    
    @objc func getUsers() {
        if self.collectionView.alpha == 1 {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.alpha = 1
            }
        }
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        print("tapped")
        if self.collectionView.alpha == 1 {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.collectionView.alpha = 1
            }
        }
    }
    
    fileprivate func fetchAllSaved() {
        users.removeAll()
        fetchBookmarkedUserIds()
    }
    
    @objc func getSegments(index: Int) {
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView.reloadData()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            collectionView.reloadData()
        }
    }
    
    var users = [User]()
    fileprivate func fetchBookmarkedUserIds() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchSelectedUsers(user: user)
        }
    }
    
    fileprivate func fetchSelectedUsers(user: User) {
        
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
                Database.database().reference().child(Constants.BookmarkedUsers).child(self.uid!).child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    
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
                })
                
            })
            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }
    }
    
    var searchUsers = [User]()
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child(Constants.Users)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                
//                if key == Auth.auth().currentUser?.uid {
//                    return
//                }
//                
//                guard let userDictionary = value as? [String: Any] else { return }
//                
//                let user = User(uid: key, dictionary: userDictionary)
//                
//                self.searchUsers.append(user)
            })
            
//            self.searchUsers.sort(by: { (u1, u2) -> Bool in
//                return u1.username.compare(u2.username) == .orderedAscending
//            })
            
            self.filteredUsers = self.searchUsers
            self.collectionView?.reloadData()
            
        }) { (err) in
            print("Failed to fetch users for search:", err)
        }
        
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
//            return user.username.lowercased().contains(text.lowercased())
//        }
//        filterSearch = self.users.filter { (user) -> Bool in
//            return user.username.lowercased().contains(text.lowercased())
//        }
        
        self.collectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return filteredUsers.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return filterSearch.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TagUsertoPhotoCell
        if segmentedControl.selectedSegmentIndex == 0 {
            cell.user = filteredUsers[indexPath.item]
            return cell
        }
        cell.user = filterSearch[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        if segmentedControl.selectedSegmentIndex == 0 {
//            let user = filteredUsers[indexPath.row]
//            selectedUser = user.uid
//            isHiddenTrue()
//            self.addUserButton.isHidden = true
//            Database.fetchUserWithUID(uid: user.uid) { (user) in
//                self.user = user
//                self.addUserLabel.text = "* Send invoice to: \(user.username)"
//            }
            
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let user = filterSearch[indexPath.row]
            guard let selectedUser = user.uid else { return }
            isHiddenTrue()
            self.addUserButton.isHidden = true
            Database.fetchUserWithUID(uid: selectedUser) { (user) in
                self.user = user
                self.addUserLabel.text = "* Send invoice to: \(user.username)"
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TagUsertoPhotoCell else { return }
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }
    
    func isHiddenTrue() {
        self.collectionView.isHidden = true
        self.searchBar.isHidden = true
        self.segmentedControl.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
    //MARK: PICKER SETUP
    func datePickerView() {
        dateView.inputView = datePicker
        dateField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.orangeColor()
        
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: #selector(todayPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dateDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Select a Date"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([todayButton, flexButton, labelButton, flexButton, doneButton], animated: true)

        dateView.inputAccessoryView = toolbar
        dateField.inputAccessoryView = toolbar
    }
    
    func startTimePickerView() {
        startView.inputView = startTimePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.orangeColor()
        
        let timeButton = UIBarButtonItem(title: "Current", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Select Start Time"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([timeButton, flexButton, labelButton, flexButton, doneButton], animated: true)

        startView.inputAccessoryView = toolbar
    }
    
    func endTimePickerView() {
        endView.inputView = endTimePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.orangeColor()
        
        let timeButton = UIBarButtonItem(title: "Current", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Select End Time"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([timeButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        
        endView.inputAccessoryView = toolbar
    }
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.time
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(startTimePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.time
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(endTimePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let dateImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "calendar_unselected")
        return image
    }()
    
    let timeImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "clock")
        return image
    }()
    
    let dateView: UITextField = {
        let text = UITextField()
        text.text = " * Date"
        text.font = UIFont.systemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.backgroundColor = UIColor.white
        text.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return text
    }()
    let dateField: UITextField = {
        let text = UITextField()
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.lightGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 2
        text.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return text
    }()
    
    let startView: UITextView = {
        let text = UITextView()
        text.text = " From"
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.lightGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 2
        text.isEditable = false
        return text
    }()
    
    let endView: UITextView = {
        let text = UITextView()
        text.text = " To"
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.lightGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 2
        text.isEditable = false
        return text
    }()
    
    @objc func dateDonePressed(sender: UIBarButtonItem) {
        dateView.resignFirstResponder()
        dateField.resignFirstResponder()
    }
    
    @objc func startDonePressed(sender: UIBarButtonItem) {
        startView.resignFirstResponder()
    }
    
    @objc func endDonePressed(sender: UIBarButtonItem) {
        endView.resignFirstResponder()
    }
    
    
    @objc func todayPressed(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        formatter.timeStyle = DateFormatter.Style.none
        
        dateField.text = formatter.string(from: NSDate() as Date)
        
        dateField.resignFirstResponder()
    }
    
    @objc func startPressed(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.none
        
        formatter.timeStyle = DateFormatter.Style.short
        
        startView.text = formatter.string(from: NSDate() as Date)
        
        startView.resignFirstResponder()
    }
    
    @objc func endPressed(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.none
        
        formatter.timeStyle = DateFormatter.Style.short
        endView.text = formatter.string(from: NSDate() as Date)
        
        endView.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let selectedDate: String = dateFormatter.string(from: sender.date)
        dateField.text = (" \(selectedDate)")
        dateField.textColor = UIColor.darkGray
        
    }
    
    @objc func startTimePickerValueChanged(_ sender: UIDatePicker){
        
        endTimePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: startTimePicker.date)
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
        
        let selectedTime: String = dateFormatter.string(from: sender.date)
        startView.text = (" From: \(selectedTime)")
        startView.textColor = UIColor.darkGray
        
    }
    
    @objc func endTimePickerValueChanged(_ sender: UIDatePicker){
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
        
        let selectedTime: String = dateFormatter.string(from: sender.date)
        endView.text = (" To: \(selectedTime)")
        endView.textColor = UIColor.darkGray
        
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: ImageUpload
    var flag = 0
    @objc func handlePhotoButton1() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true
//
//        present(imagePickerController, animated: true, completion: nil)
        flag = 1
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            
        }
    }
    
    @objc func handlePhotoButton2() {
        flag = 2
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            photoImageView1.image = editedImage
//        } else if let originalImage =
//            info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            photoImageView1.image = originalImage
//        }
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            
            if flag == 1
            {
                addPhotoButton.setBackgroundImage(image, for: .normal)
                photoImageView1.image = image
            }
            else if flag == 2
            {
                addPhotoButton2.setBackgroundImage(image, for: .normal)
                photoImageView2.image = image
            }

        }
        


        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Send
        
        @objc func validForm() {
            let isFormValid = referenceField.text?.count ?? 0 > 0 && addUserLabel.text?.count ?? 0 > 0 && dateView.text?.count ?? 0 > 0 && amountField.text?.count ?? 0 > 0
            
            if isFormValid {
                sendInvoiceButton.isEnabled = true
                sendInvoiceButton.backgroundColor = UIColor.orangeColor()
            } else {
                sendInvoiceButton.isEnabled = false
                sendInvoiceButton.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(0.8)
            }
        }
        
        var selectedImage1: UIImage? {
            didSet {
                self.photoImageView1.image = selectedImage1
            }
        }
        
        var selectedImage2: UIImage? {
            didSet {
                self.photoImageView2.image = selectedImage2
            }
        }
        
        var selectedImage3: UIImage? {
            didSet {
                self.photoImageView3.image = selectedImage3
            }
        }
        
        @objc func handleShare() {
//            guard let image = selectedImage else {return}
//            guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
//            let filename = NSUUID().uuidString
//
//            let storageRef = Storage.storage().reference().child(Constants.SharedPhotos).child(filename)
//
//            storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
//                if let err = err {
//                    print(err)
//                    return
//                }
//
//                storageRef.downloadURL(completion: { (downloadURL, err) in
//                    if let err = err {
//                        print("Failed to retrieve downloadURL:", err)
//                        return
//                    }
//                    guard let imageUrl = downloadURL?.absoluteString else { return }
//
//                    print("Successfully uploaded post image:", imageUrl)
//
//                    self.saveToDatabase(imageUrl: imageUrl)
//                })
//            }
        }
        
        static let updateNotificationName = NSNotification.Name(rawValue: "Update")
        
        fileprivate func saveToDatabase(imageUrl: String) {
            let totalAmount = amountField.text
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .currency
                    let number = formatter.number(from: totalAmount!)
                    let amount = number!.doubleValue
                    let total = amount * 100
                    print("stripe: \(total)")
                    print("amount: \(amount)")
                    
                    
                    guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
                    guard let paymentReference = referenceField.text else {return}
                    guard let description = descriptionField.text else {return}

                    let getSelectedUser = selectedUser

                    let ref = Database.database().reference().child(Constants.Payments)
                    let invoiceRef = Database.database().reference().child(Constants.Invoices)
                    let key = ref.childByAutoId().key
                    let timeStamp = Date().timeIntervalSince1970
                    let values = [Constants.EventDate: self.dateField.text ?? "", Constants.StartTime: self.startView.text ?? "", Constants.EndTime: self.endView.text ?? "",Constants.PaymentReference: paymentReference, Constants.Description: description, Constants.Amount: total, "currency": amount, Constants.FromUser: currentUserUid, Constants.ToUser: getSelectedUser, Constants.Key: key!, Constants.Status: "Pending", Constants.Timestamp: timeStamp] as [String : Any]

                    ref.child(key!).updateChildValues(values) { (err, ref) in

                        if let err = err {
                            print("Failed to insert comment:", err)
                            return
                        }

                        let notificationValue = [key!: 1] as [String : Any]
                        let userValue = [key!: 0] as [String : Any]
                        invoiceRef.child(currentUserUid).updateChildValues(userValue)
                        invoiceRef.child(getSelectedUser).updateChildValues(notificationValue)
            //            self.sendNotification(fromId: currentUserUid, toId: getSelectedUser, paymentId: key ?? "", timestamp: timeStamp as Double, paymentReference: paymentReference)

                    }
                    let alert = UIAlertController(title: "Payment Request has been sent", message: "Check payment status in your invoices", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    referenceField.text = ""
                    descriptionField.text = ""
                    amountField.text = ""
                    addUserLabel.text = "Send invoice to: ADD USER"
                    selectedUser = ""
            
//            guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
//            guard let sharedImage = selectedImage else {return}
//            guard let caption = textView.text else {return}
//            let getSelectedUser = selectedUser
    
//            let postRef = Database.database().reference().child(Constants.Gallery).child(currentUserUid)
//            let key = postRef.childByAutoId().key
//            let values = [Constants.ImageUrl: imageUrl, Constants.Caption: caption, Constants.Width: sharedImage.size.width, Constants.Height: sharedImage.size.height, Constants.CreationDate: Date().timeIntervalSince1970, Constants.LikeCount: 0, Constants.Location: locationTextField.text ?? "", Constants.BookmarkedUser: getSelectedUser, Constants.Id: key ?? ""] as [String : Any]
    
//            postRef.child(key!).updateChildValues(values) { (err, ref) in
//                if let err = err {
//                    print("there was an error", err )
//                    return
//                }
//                print("saved photo to database")
//                let homeVC = HomeVC(collectionViewLayout: UICollectionViewFlowLayout())
//                self.navigationController?.pushViewController(homeVC, animated: true)
//                NotificationCenter.default.post(name: SharePhotoVC.updateNotificationName, object: nil)
//            }

        }
        
        @objc func handleSend() {
            let totalAmount = amountField.text
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            let number = formatter.number(from: totalAmount!)
            let amount = number!.doubleValue
            let total = amount * 100
            print("stripe: \(total)")
            print("amount: \(amount)")
            
            
            guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
            guard let paymentReference = referenceField.text else {return}
            guard let description = descriptionField.text else {return}

            let getSelectedUser = selectedUser

            let ref = Database.database().reference().child(Constants.Payments)
            let invoiceRef = Database.database().reference().child(Constants.Invoices)
            let key = ref.childByAutoId().key
            let timeStamp = Date().timeIntervalSince1970
            let values = [Constants.EventDate: self.dateField.text ?? "", Constants.StartTime: self.startView.text ?? "", Constants.EndTime: self.endView.text ?? "",Constants.PaymentReference: paymentReference, Constants.Description: description, Constants.Amount: total, "currency": amount, Constants.FromUser: currentUserUid, Constants.ToUser: getSelectedUser, Constants.Key: key!, Constants.Status: "Pending", Constants.Timestamp: timeStamp] as [String : Any]

            ref.child(key!).updateChildValues(values) { (err, ref) in

                if let err = err {
                    print("Failed to insert comment:", err)
                    return
                }

                let notificationValue = [key!: 1] as [String : Any]
                let userValue = [key!: 0] as [String : Any]
                invoiceRef.child(currentUserUid).updateChildValues(userValue)
                invoiceRef.child(getSelectedUser).updateChildValues(notificationValue)
    //            self.sendNotification(fromId: currentUserUid, toId: getSelectedUser, paymentId: key ?? "", timestamp: timeStamp as Double, paymentReference: paymentReference)

            }
            let alert = UIAlertController(title: "Payment Request has been sent", message: "Check payment status in your invoices", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)

            referenceField.text = ""
            descriptionField.text = ""
            amountField.text = ""
            addUserLabel.text = "Send invoice to: ADD USER"
            selectedUser = ""
            
            
        }
        
        func sendNotification(fromId: String, toId: String, paymentId: String, timestamp: Double, paymentReference: String) {
            
            let values = [Constants.FromId: fromId, Constants.ToId: toId, "reference": paymentReference, "notificationType": "payment", Constants.Timestamp: timestamp, "paymentId": paymentId] as [String : Any]
            
            Database.database().reference().child("notifications").child(toId).child(paymentId).setValue(values)
        }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

// custom class for file uploading
//class FirFile: NSObject {
//
//    /// Singleton instance
//    static let shared: FirFile = FirFile()
//
//    /// Path
//    let kFirFileStorageRef = Storage.storage().reference().child("Files")
//
//    /// Current uploading task
//    var currentUploadTask: StorageUploadTask?
//
//    func upload(data: Data,
//                withName fileName: String,
//                block: @escaping (_ url: String?) -> Void) {
//
//        // Create a reference to the file you want to upload
//        let fileRef = kFirFileStorageRef.child(fileName)
//
//        /// Start uploading
//        upload(data: data, withName: fileName, atPath: fileRef) { (url) in
//            block(url)
//        }
//    }
//
//    func upload(data: Data,
//                withName fileName: String,
//                atPath path:StorageReference,
//                block: @escaping (_ url: String?) -> Void) {
//
//        // Upload the file to the path
//        self.currentUploadTask = path.putData(data, metadata: nil) { (metaData, error) in
//             guard let metadata = metadata else {
//                  // Uh-oh, an error occurred!
//                  block(nil)
//                  return
//             }
//             // Metadata contains file metadata such as size, content-type.
//             // let size = metadata.size
//             // You can also access to download URL after upload.
//             path.downloadURL { (url, error) in
//                  guard let downloadURL = url else {
//                     // Uh-oh, an error occurred!
//                     block(nil)
//                     return
//                  }
//                 block(url)
//             }
//        }
//    }
//
//    func cancel() {
//        self.currentUploadTask?.cancel()
//    }
//}
//
//        guard let image = selectedImage else {return}
//        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
//        let filename = NSUUID().uuidString
//
//        let storageRef = Storage.storage().reference().child(Constants.SharedPhotos).child(filename)
//
//        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
//            if let err = err {
//                print(err)
//                return
//            }
//
//            storageRef.downloadURL(completion: { (downloadURL, err) in
//                if let err = err {
//                    print("Failed to retrieve downloadURL:", err)
//                    return
//                }
//                guard let imageUrl = downloadURL?.absoluteString else { return }
//
//                print("Successfully uploaded post image:", imageUrl)
//
//                self.saveToDatabase(imageUrl: imageUrl)
//            })
//        }


