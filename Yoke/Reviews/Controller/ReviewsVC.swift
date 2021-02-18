//
//  ReviewsVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class ReviewsVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, FloatRatingViewDelegate {
    
    var review: Review?
    
    let cellId = "cellId"
    let noCellId = "noCellId"
    var uid = Auth.auth().currentUser?.uid
    var userId: String?
    var user: User? {
        didSet {
            guard let user = user else { return }
            let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        }
    }
//    var user: User?
    fileprivate func fetchUser() {
        guard let uid = self.user?.uid else { return }
        
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
            self.navigationItem.title = "Reviews"
            self.collectionView?.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ReviewsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)

        fetchReviews()
        fetchUser()
        setupNavTitleAndBarButtonItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupNavTitleAndBarButtonItems() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(newReview))
    }
    
    @objc func newReview() {
        let addReview = NewReviewVC()
        addReview.user = user
        present(addReview, animated: true, completion: nil)
//        navigationController?.pushViewController(addReview, animated: true)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    var reviews = [Review]()
    fileprivate func fetchReviews() {
//        let userId = self.user?.uid ?? ""
//        let ref = Database.database().reference().child(Constants.Reviews).child(userId)
//        
//        ref.observe(.childAdded, with: { (snapshot) in
//            
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            
//            guard let uid = dictionary[Constants.Uid] as? String else { return }
//            Database.fetchUserWithUID(uid: uid, completion: { (user) in
//                let review = Review(user: user, dictionary: dictionary)
//                self.reviews.append(review)
//                self.collectionView?.reloadData()
//                
//                self.reviews.sort(by: { (review1, review2) -> Bool in
//                    return review1.creationDate?.compare(review2.creationDate!) == .orderedDescending
//                })
//            })
//            
//        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if reviews.count == 0 {
            return 1
        } else {
            return reviews.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if reviews.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.noPostLabel.text = "No Reviews yet"
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ReviewsCell
        cell.review = self.reviews[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if reviews.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.photoImageView.image = UIImage(named: "no_post_background")!
            noCell.noPostLabel.text = "No Reviews yet"
            return CGSize(width: view.frame.width, height: 75)
        } else {
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            let dummyCell = ReviewsCell(frame: frame)
            dummyCell.review = reviews[indexPath.item]
            dummyCell.layoutIfNeeded()
            
            let targetSize = CGSize(width: view.frame.width, height: 1000)
            let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
            
            let height = max(40 + 8 + 8, estimatedSize.height)
            return CGSize(width: view.frame.width, height: height)
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

//    let rateLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.white
//        label.text = "Select your rating"
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
//
//    let ratingView: RatingView = {
//        let view = RatingView()
//        view.backgroundColor = .clear
//        view.minRating = 0
//        view.maxRating = 5
//        view.rating = 0
//        view.editable = true
//        view.emptyImage = UIImage(named: "star_unselected_white")
//        view.fullImage = UIImage(named: "star_selected_white")
//        return view
//    }()
    
//    func didSubmit(for review: String) {
//        let userId = self.user?.uid ?? ""
//        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
//
//        let ref = Database.database().reference().child(Constants.Reviews).child(userId).childByAutoId()
//        let checkUserRef = Database.database().reference().child(Constants.Ratings).child(userId).child(currentUserId)
//        let ratingsRef = Database.database().reference().child(Constants.Ratings).child(userId)
//
//
//        let liveRate = self.ratingView.rating
//        let rateValues = [currentUserId: liveRate]
//        let values = [Constants.Text: review, Constants.CreationDate: Date().timeIntervalSince1970, Constants.Uid: currentUserId, Constants.Ratings: liveRate] as [String : Any]
//
//        let isValid = self.review?.text.count ?? 0 > 0 && liveRate >= 1
//
//        checkUserRef.observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.exists() {
//                if isValid {
//                    ratingsRef.updateChildValues(rateValues)
//                    ref.updateChildValues(values)
//                    self.updatedRatingAlert()
//                } else {
//                    self.ratingReviewErrorAlert()
//                }
//
//            } else {
//                print("not rated")
//                if liveRate >= 1 {
//                    ref.updateChildValues(values)
//                    ratingsRef.updateChildValues(rateValues)
//                    self.ratingAddedAlert()
//                } else {
//                    self.errorAlert()
//                }
//            }
//        }
//
//        self.containerView.clearReviewTextField()
//        self.ratingView.rating = 0
//    }
//
//    func ratingReviewErrorAlert() {
//        let alert = UIAlertController(title: "Please try again", message: "You must enter a new star rating and explain why your rating has changed", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func errorAlert() {
//        let alert = UIAlertController(title: "Please try again", message: "You must enter a star rating to continue", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func ratingAddedAlert() {
//        let alert = UIAlertController(title: "Success", message: "Your review and rating has been added", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func updatedRatingAlert() {
//        let alert = UIAlertController(title: "Success", message: "Your review and rating has been updated", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    lazy var containerView: ReviewInputAccessoryView = {
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        let reviewInputAccessoryView = ReviewInputAccessoryView(frame: frame)
//        reviewInputAccessoryView.delegate = self
//        return reviewInputAccessoryView
//    }()
//
//    func setupRating() {
//        containerView.addSubview(ratingView)
//        ratingView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 200, height: 24)
//
//        containerView.addSubview(rateLabel)
//        rateLabel.anchor(top: containerView.topAnchor, left: ratingView.rightAnchor, bottom: ratingView.bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 5, width: 0, height: 0)
//
//    }
//
//    override var inputAccessoryView: UIView? {
//        get {
//            return containerView
//        }
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
}


