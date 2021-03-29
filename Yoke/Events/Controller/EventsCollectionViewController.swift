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
        let filterIcon = UIImage(named: "filterOrange")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.image = filterIcon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(handleFilter))
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
    
    @objc func handleFilter() {
        
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if EventController.shared.events.count == 0 {
            return 1
        } else {
            return EventController.shared.filteredEvents.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCollectionViewCell
        if EventController.shared.filteredEvents.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "No events in your area"
            return noCell
        }
        cell.event = EventController.shared.filteredEvents[indexPath.item]
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if EventController.shared.filteredEvents.count == 0 {
            return CGSize(width: view.frame.width, height: 200)
        }
        if let captionText = EventController.shared.filteredEvents[indexPath.item].caption {
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
            EventController.shared.filteredEvents = EventController.shared.events
        } else {
            EventController.shared.filteredEvents = EventController.shared.events.filter({ (event) -> Bool in
                guard let caption = event.caption else { return false }
                return caption.lowercased().contains(searchText.lowercased())
            })
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
