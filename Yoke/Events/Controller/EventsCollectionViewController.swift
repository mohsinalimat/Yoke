//
//  EventsCollectionViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/22/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class EventsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    

    //MARK: Properties
    let cellId = "cellId"
    let noCellId = "noCellId"
    var userId: String?
    var searchController = UISearchController()
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupCollectionView()
        fetchEvents()
        setupSearch()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Events", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "new", style: .plain, target: self, action: #selector(newEvent))
    }
    
    func setupSearch() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for tools and resources"
        searchController.searchBar.sizeToFit()

        searchController.searchBar.becomeFirstResponder()

        navigationItem.titleView = searchController.searchBar
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.LightGrayBg()
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    func fetchEvents() {
        EventController.shared.fetchEvents() { (result) in
            switch result {
            default:
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Selectors
    @objc func newEvent() {
        print("new")
        let addEvent = NewEventViewController()
        present(addEvent, animated: true)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if EventController.shared.events.count == 0 {
            return 1
        } else {
            return EventController.shared.events.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCollectionViewCell
        if EventController.shared.events.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "No events in your area"
            return noCell
        }
        cell.event = EventController.shared.events[indexPath.item]
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        return
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if EventController.shared.events.count == 0 {
            return CGSize(width: view.frame.width, height: 200)
        }
        if let captionText = EventController.shared.events[indexPath.item].caption {
            let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)], context: nil)
            let imageHeight = view.frame.width
            return CGSize(width: view.frame.width, height: imageHeight + rect.height + 190)
        }
        return CGSize(width: view.frame.width, height: 400)
    }
}

extension EventsCollectionViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
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
            self.collectionView.reloadData()
        }
    }
}
