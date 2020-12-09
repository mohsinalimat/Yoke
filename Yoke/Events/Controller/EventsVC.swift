//
//  EventsVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class EventsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchControllerDelegate, SearchEventsFilterDelegate {
    
    private let eventCell = "eventCell"
    let headerId = "headerId"
    
    var searchController : UISearchController!
    
    var uid = Auth.auth().currentUser?.uid
    var userId: String?
    var user: User?
    var isFinishedPaging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(EventCell.self, forCellWithReuseIdentifier: eventCell)
        collectionView?.alwaysBounceVertical = true
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
        collectionView?.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        view.backgroundColor = UIColor.white
        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        collectionView?.refreshControl = refreshControl
        
        fetchEvent()
        setupNavTitleAndBarButtonItems()
        handleEventSearch()
        
    }
    
    @objc func handleRefresh() {
        print("refresh")
        events.removeAll()
        fetchEvent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        searchBar.isHidden = false
    }
    
    
    fileprivate func setupNavTitleAndBarButtonItems() {
        
        self.navigationItem.title = "Events"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Event", style: .plain, target: self, action: #selector(self.handleNewEvent))
    }
    
    @objc func handleNewEvent() {
        let newEvent = NewEventVC()
        let navController = UINavigationController(rootViewController: newEvent)
        present(navController, animated: true, completion: nil)
    }
    
    fileprivate func handleEventSearch() {
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.searchController.obscuresBackgroundDuringPresentation = false

        view.addSubview(searchBar)
        searchBar.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(searchFilterButton)
        searchFilterButton.anchor(top: searchBar.topAnchor, left: searchBar.rightAnchor, bottom: searchBar.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 45, height: 45)
    }
    
    fileprivate func paginatePosts() {
        
        guard let uid = self.user?.uid else { return }
        let ref = Database.database().reference().child(Constants.Event).child(uid)

        var query = ref.queryOrdered(byChild: Constants.CreationDate)
        
        if events.count > 0 {
            let value = events.last?.creationDate?.timeIntervalSince1970
            query = query.queryEnding(atValue: value)
        }
        
        query.queryLimited(toLast: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard var allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.reverse()
            
            if allObjects.count < 4 {
                self.isFinishedPaging = true
            }
            
            if self.events.count > 0 && allObjects.count > 0 {
                allObjects.removeFirst()
            }
            
            guard let user = self.user else { return }
            
            allObjects.forEach({ (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                let event = Event(user: user, dictionary: dictionary, snapshot: snapshot)
                event.id = snapshot.key
                
                self.events.append(event)
            
            })
            
            self.events.forEach({ (post) in
                
            })
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
            
        }) { (err) in
            print("Failed to paginate for posts:", err)
        }
    }
    
    var events = [Event]()
    var filteredEvents = [Event]()
    fileprivate func fetchEvent() {
        
//        self.collectionView?.refreshControl?.endRefreshing()
        
        let ref = Database.database().reference().child(Constants.Event)
        ref.observe( .childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let uid = dictionary[Constants.Uid] as? String else {return}
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                let event = Event(user: user, dictionary: dictionary, snapshot: snapshot)
                self.events.insert(event, at: 0)
                self.filteredEvents = self.events
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            })
            
        })

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredEvents = self.events
        } else {
            filteredEvents = self.events.filter({ (event) -> Bool in
                return (event.postText?.lowercased().contains(searchText.lowercased()))! || (event.user.username.lowercased().contains(searchText.lowercased()))
            })
        }

        print("there are no users based on your search")

        self.collectionView?.reloadData()
        
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredEvents.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == self.events.count - 1 && !isFinishedPaging {
            paginatePosts()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventCell, for: indexPath) as! EventCell
        
        cell.event = filteredEvents[indexPath.item]
        cell.user = user
        cell.postTextView.isUserInteractionEnabled = false
        if filteredEvents[indexPath.item].eventImageUrl == "" {
            cell.photoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 1)
        }

        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.shadowRadius = 3.0
        cell.layer.shadowOpacity = 0.5
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()

        let event = events[indexPath.row]
        let eventDetailVC = EventDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
        eventDetailVC.event = event
        navigationController?.pushViewController(eventDetailVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = events[indexPath.item].postText {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], context: nil)
            
            if events[indexPath.item].eventImageUrl == "" {
               let knownHeight: CGFloat = 80 + 1
                return CGSize(width: view.frame.width, height: knownHeight + rect.height)
            }
            
            let knownHeight: CGFloat = view.frame.width + 40
            return CGSize(width: view.frame.width, height: knownHeight + rect.height)
        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath as IndexPath)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    var searchFilterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "filter.png"), for: .normal)
        button.backgroundColor = UIColor.mainColor()
        button.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        button.addTarget(self, action: #selector(handleFilter), for: .touchUpInside)
        return button
    }()
    
    func searchEventsFilterController(_ searchFilterController: EventsFilterVC, didSaveSearch location: String, cusine: String, date: String, chefType: String) {
        print("We are back")
    }
    
    @objc func handleFilter() {
        //        clearValues()
        let searchFilter = EventsFilterVC()
        searchFilter.delegate = self
        present(searchFilter, animated: true, completion: nil)
        collectionView?.reloadData()
    }
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search by: Keyword or Username"
        search.backgroundColor = UIColor.white
        search.barTintColor = UIColor.white
        search.searchBarStyle = .minimal
        search.setTextColor(color: UIColor.black)
        search.setTextFieldColor(color: UIColor.white)
        search.setPlaceholderTextColor(color: UIColor.lightGray)
        search.setSearchImageColor(color: UIColor.white)
        search.setTextFieldClearButtonColor(color: UIColor.mainColor())
        search.delegate = self
        return search
    }()
}



