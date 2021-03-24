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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupCollectionView()
        fetchEvents()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Events", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "new", style: .plain, target: self, action: #selector(newEvent))
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
//        if let captionText = EventController.shared.events[indexPath.item].caption {
//            let rect = NSString(string: captionText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
//            return CGSize(width: view.frame.width, height: rect.height + 90)
//        }
        return CGSize(width: view.frame.width, height: 300)
    }
}
