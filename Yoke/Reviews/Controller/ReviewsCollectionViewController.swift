//
//  ReviewsCollectionViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/18/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class ReviewsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FloatRatingViewDelegate {
    
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
        fetchReviews()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Reviews", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = UIColor.LightGrayBg()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "new", style: .plain, target: self, action: #selector(newReview))
        collectionView.register(ReviewsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    //MARK: - Selectors
    @objc func newReview() {
        let reviewsVC = NewReviewViewController()
        reviewsVC.userId = userId
        present(reviewsVC, animated: true)
    }
    
    //MARK: - API
    func fetchReviews() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            ReviewController.shared.fetchReviewsFor(uid: uid) { (result) in
                switch result {
                case true:
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                case false:
                    print("failed to fetch reviews")
                }
            }
        }
        
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if ReviewController.shared.reviews.count == 0 {
            return 1
        }
        return ReviewController.shared.reviews.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if ReviewController.shared.reviews.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "No Reviews yet"
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReviewsCollectionViewCell
        cell.review = ReviewController.shared.reviews[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if ReviewController.shared.reviews.count == 0 {
            return CGSize(width: view.frame.width, height: 200)
        }
        if let reviewText = ReviewController.shared.reviews[indexPath.item].review {
            let rect = NSString(string: reviewText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
            return CGSize(width: view.frame.width, height: rect.height + 90)
        }
        return CGSize(width: view.frame.width, height: 500)
    }
}
