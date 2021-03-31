//
//  ChefsEventsCollectionViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/26/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChefsEventsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Properties
    let cellId = "cellId"
    let noCellId = "noCellId"
    var userId: String?
    
    //MARK: Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchEvents()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Your Events", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
        let newIcon = UIImage(named: "add-filled")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.image = newIcon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: newIcon, style: .plain, target: self, action: #selector(newEvent))
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.LightGrayBg()
        collectionView.register(ChefsEventsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    func fetchEvents() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            EventController.shared.fetchEventWith(uid: uid) { (result) in
                switch result {
                case true:
                    self.collectionView.reloadData()
                    print("got it")
                case false:
                    print("error fetching events")
                }
            }
        }
    }
    
    //MARK: - Selectors
    @objc func newEvent() {
        let addEvent = NewEventViewController()
        present(addEvent, animated: true)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EventController.shared.events.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChefsEventsCollectionViewCell
        if EventController.shared.events.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "You have no events."
            return noCell
        }
        cell.event = EventController.shared.events[indexPath.item]
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if EventController.shared.events.count == 0 {
            return
        } else {
            let event = EventController.shared.events[indexPath.item]
            let eventVC = NewEventViewController()
            eventVC.event = event
            eventVC.eventLabel.text = "Edit Menu"
            eventVC.eventDetailTextField.placeholder = ""
            eventVC.deleteButton.isHidden = false
            eventVC.eventExist = true
            eventVC.saveButton.setTitle("Update", for: .normal)
            present(eventVC, animated: true)
        }
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if EventController.shared.events.count == 0 {
            return CGSize(width: view.frame.width, height: 200)
        }
        return CGSize(width: view.frame.width, height: 150)
    }

}
