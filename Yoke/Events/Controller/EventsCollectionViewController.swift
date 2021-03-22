//
//  EventsCollectionViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/22/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class EventsCollectionViewController: UICollectionViewController {

    //MARK: Properties
    let cellId = "cellId"
    let noCellId = "noCellId"
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Events", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.LightGrayBg()
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "new", style: .plain, target: self, action: #selector(newReview))
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCollectionViewCell
        if ReviewController.shared.reviews.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "No Reviews yet"
            return noCell
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
