//
//  SharePhotoVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoVC: UIViewController, UITextViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchControllerDelegate {
    
    var collectionView: UICollectionView!
    var uid = Auth.auth().currentUser?.uid
    var selectedUser: String = ""
    var filteredUsers = [User]()
    var filterSearch = [User]()
    let cellId = "cellId"
    var searchController : UISearchController!
    var tapGesture = UITapGestureRecognizer()
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    var user: User?
    var gallery: Gallery?
    fileprivate func fetchSelectedUser() {
        selectedUser = (gallery?.BookmarkedUser)!
        let uid = selectedUser
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            let profileImageUrl = user.profileImageUrl
            self.userProfileImageView.loadImage(urlString: profileImageUrl)
            self.addUserLabel.text = user.username
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleAddUser))
        userProfileImageView.addGestureRecognizer(tapGestureRecognizer)
        userProfileImageView.isUserInteractionEnabled = true
        
        textView.delegate = self
        setupNavTitleAndBarButtonItems()
        setupViews()
        fetchUsers()
        fetchAllSaved()
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(SharePhotoVC.myviewTapped(_:)))
        addUserLabel.addGestureRecognizer(tapGesture)
        addUserLabel.isUserInteractionEnabled = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.textView.becomeFirstResponder()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Add Caption"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action:  #selector(handleShare))
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor.darkGray
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.layer.cornerRadius = 5
        textView.text = nil
        textView.placeholder = "Add a caption"
        return textView
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    let locationTextField: UITextView = {
        let text = UITextView()
        text.placeholder = "Location"
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.font = UIFont.systemFont(ofSize: 14)
        text.layer.cornerRadius = 5
        text.textColor = UIColor.darkGray
        return text
    }()
    
    let locationImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "location")
        return image
    }()
    
    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "addPhotoSalmon")
        return image
    }()
    
    let addUserLabel: UILabel = {
       let label = UILabel()
        label.text = "Tag a user"
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    func textViewDidChange(_ textView: UITextView) {
        countLabel.text = "\(150 - textView.text.count) characters left"
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
        search.isHidden = true
        return search
    }()
    
    let userView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isHidden = true
        return view
    }()
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor.mainColor()
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    @objc func handleDismiss() {
        collectionView.isHidden = true
        userView.isHidden = true
    }
    
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["All Users","Saved Users"])
        seg.selectedSegmentIndex = 0
        seg.backgroundColor = UIColor.mainColor()
        seg.tintColor = UIColor.white
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.selected)
        seg.isHidden = true
        seg.addTarget(self, action: #selector(getSegments), for: .valueChanged)
        return seg
    }()
    
    let CharacterLimit = 150
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count > 0 {
            textView.placeholder = ""
        } else {
            textView.placeholder = "Add a caption"
        }
        let currentText = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with: text)

        return updatedText.count <= CharacterLimit
    }
    
    fileprivate func setupViews() {
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 5, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(textView)
        textView.anchor(top: view.topAnchor, left: imageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 10, paddingRight: 15, width: 0, height: 100)
        
        view.addSubview(countLabel)
        countLabel.anchor(top: textView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        view.addSubview(locationImageView)
        locationImageView.anchor(top: countLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 10, paddingRight: 5, width: 30, height: 30)
        
        view.addSubview(locationTextField)
        locationTextField.anchor(top: countLabel.bottomAnchor, left: locationImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 15, width: 0, height: 35)

        view.addSubview(userProfileImageView)
        userProfileImageView.anchor(top: locationTextField.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        userProfileImageView.layer.cornerRadius = 50 / 2
        userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(addUserLabel)
        addUserLabel.anchor(top: userProfileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(userView)
        userView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        userView.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 10, paddingRight: 10, width: 50, height: 50)
        dismissButton.layer.cornerRadius = 50/2
        
        userView.addSubview(segmentedControl)
        segmentedControl.anchor(top: dismissButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.frame.width, height: 35)
        
        userView.addSubview(searchBar)
        searchBar.anchor(top: segmentedControl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
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
        self.collectionView.isHidden = !self.collectionView.isHidden
        
        userView.addSubview(collectionView)
        collectionView.anchor(top: searchBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        
    }
    
    //MARK: functions
    
    @objc func handleAddUser() {
        if self.collectionView.isHidden == false  {
            self.dismissButton.isHidden = true
            self.collectionView.isHidden = true
            self.searchBar.isHidden = true
            self.segmentedControl.isHidden = true
        } else {
            self.dismissButton.isHidden = false
            self.collectionView.isHidden = false
            self.searchBar.isHidden = false
            self.segmentedControl.isHidden = false
        }
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        if self.collectionView.isHidden == false  {
            self.userView.isHidden = true
            self.dismissButton.isHidden = true
            self.collectionView.isHidden = true
            self.searchBar.isHidden = true
            self.segmentedControl.isHidden = true
        } else {
            self.userView.isHidden = false
            self.dismissButton.isHidden = false
            self.collectionView.isHidden = false
            self.searchBar.isHidden = false
            self.segmentedControl.isHidden = false
        }
    }
    
    @objc func handleShare() {
        guard let image = selectedImage else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else {return}
        let filename = NSUUID().uuidString

        let storageRef = Storage.storage().reference().child(Constants.SharedPhotos).child(filename)

        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print(err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to retrieve downloadURL:", err)
                    return
                }
                guard let imageUrl = downloadURL?.absoluteString else { return }
                
                print("Successfully uploaded post image:", imageUrl)
                
                self.saveToDatabase(imageUrl: imageUrl)
            })
        }
    }
    
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    fileprivate func saveToDatabase(imageUrl: String) {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        guard let sharedImage = selectedImage else {return}
        guard let caption = textView.text else {return}
        let getSelectedUser = selectedUser

        let postRef = Database.database().reference().child(Constants.Gallery).child(currentUserUid)
        let key = postRef.childByAutoId().key
        let values = [Constants.ImageUrl: imageUrl, Constants.Caption: caption, Constants.Width: sharedImage.size.width, Constants.Height: sharedImage.size.height, Constants.CreationDate: Date().timeIntervalSince1970, Constants.LikeCount: 0, Constants.Location: locationTextField.text ?? "", Constants.BookmarkedUser: getSelectedUser, Constants.Id: key ?? ""] as [String : Any]
        
        postRef.child(key!).updateChildValues(values) { (err, ref) in
            if let err = err {
                print("there was an error", err )
                return
            }
            print("saved photo to database")
            let homeVC = HomeVC(collectionViewLayout: UICollectionViewFlowLayout())
            self.navigationController?.pushViewController(homeVC, animated: true)
            NotificationCenter.default.post(name: SharePhotoVC.updateNotificationName, object: nil)
        }

    }
    
    //MARK: Collection View
    
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
        
//        FIRDatabase.fetchChefWithUID(uid: uid) { (user) in
//            self.fetchUsers(user: user)
//        }
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
                    
                    let user = User(uid: key, dictionary: userDictionary)
                    
                    if let value = snapshot.value as? Int, value == 1 {
                        user.isSaved = true
                        self.users.append(user)
                        self.users.sort(by: { (u1, u2) -> Bool in
                            return u1.username.compare(u2.username) == .orderedAscending
                        })
                    } else {
                        user.isSaved = false
                    }
                    self.filterSearch = self.users
                    self.collectionView?.reloadData()
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
                
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = User(uid: key, dictionary: userDictionary)
                
                self.searchUsers.append(user)
            })
            
            self.searchUsers.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            
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
        filteredUsers = self.searchUsers.filter { (user) -> Bool in
            return user.username.lowercased().contains(text.lowercased())
        }
        filterSearch = self.users.filter { (user) -> Bool in
            return user.username.lowercased().contains(text.lowercased())
        }
        
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
            let user = filteredUsers[indexPath.row]
            selectedUser = user.uid
            isHiddenTrue()
            Database.fetchUserWithUID(uid: user.uid) { (user) in
                self.user = user
                let profileImageUrl = user.profileImageUrl
                self.userProfileImageView.loadImage(urlString: profileImageUrl)
                self.addUserLabel.text = user.username
            }

        } else if segmentedControl.selectedSegmentIndex == 1 {
            let user = filterSearch[indexPath.row]
            selectedUser = user.uid
            isHiddenTrue()
            Database.fetchUserWithUID(uid: user.uid) { (user) in
                self.user = user
                let profileImageUrl = user.profileImageUrl
                self.userProfileImageView.loadImage(urlString: profileImageUrl)
                self.addUserLabel.text = user.username
            }
        }
        
    }
    
    func isHiddenTrue() {
        self.userView.isHidden = true
        self.dismissButton.isHidden = true
        self.collectionView.isHidden = true
        self.searchBar.isHidden = true
        self.segmentedControl.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 75)
    }
    
}
