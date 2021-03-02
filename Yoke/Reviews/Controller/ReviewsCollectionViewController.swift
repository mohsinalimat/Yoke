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

    let cellId = "cellId"
    let noCellId = "noCellId"
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fetchReviews()
    }
    
    //MARK: - Helper Functions
    func setupCollectionView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "new", style: .plain, target: self, action: #selector(newReview))
        collectionView.backgroundColor = .white
        collectionView.register(ReviewsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    //MARK: - Selectors
    @objc func newReview() {
        let reviewsVC = NewReviewViewController()
        reviewsVC.userId = userId
        present(reviewsVC, animated: true)
//        navigationController?.pushViewController(reviewsVC, animated: true)
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
            return CGSize(width: view.frame.width, height: rect.height + 80)
        }
//        else {
//            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//            let dummyCell = ReviewsCollectionViewCell(frame: frame)
//            dummyCell.review = ReviewController.shared.reviews[indexPath.item]
//
////            dummyCell.layoutIfNeeded()
////
////            let targetSize = CGSize(width: view.frame.width, height: 1000)
////            let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
////
////            let height = max(40 + 8 + 8, estimatedSize.height)
////            return CGSize(width: view.frame.width, height: height)
//        }
        return CGSize(width: view.frame.width, height: 500)
    
    }

}
