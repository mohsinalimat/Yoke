//
//  BookmarkedViewController.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class BookmarkedViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var uid = Auth.auth().currentUser?.uid
    
    let cellId = "cellId"
    let eventId = "eventId"

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Users","Events"])
        seg.selectedSegmentIndex = 0
        seg.layer.cornerRadius = 10
        seg.layer.borderWidth = 0.5
        seg.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        let image = UIImage(named: "whiteBG")
        seg.setBackgroundImage(image, for: .normal, barMetrics: .default)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orangeColor()!], for: UIControl.State.selected)
        seg.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)], for: UIControl.State.normal)
        seg.addTarget(self, action: #selector(getSegments), for: .valueChanged)
        return seg
    }()
    
    @objc func getSegments(index: Int) {
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView?.reloadData()
        } else if segmentedControl.selectedSegmentIndex == 1 {
            collectionView?.reloadData()
        }
    }


    var events = [Event]()
    fileprivate func fetchEvents() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        BookmarkController.shared.fetchBookmarkedUserWith(uid: currentUserId) { result in
            switch result {
            case true:
                print("true")
            case false:
                print("false")
            }
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return BookmarkController.shared.users.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return events.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if segmentedControl.selectedSegmentIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventId, for: indexPath) as! BookmarkedEventsCell
            cell.event = events[indexPath.item]
            return cell
        } else if segmentedControl.selectedSegmentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BookmarkedUsersCell
            cell.user = BookmarkController.shared.users[indexPath.item]
            return cell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            let user = users[indexPath.row]
//            let userProfileVC = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
//            userProfileVC.userId = user.uid
//            navigationController?.pushViewController(userProfileVC, animated: true)
//        } else if segmentedControl.selectedSegmentIndex == 1 {
//            let event = events[indexPath.row]
//            let eventDetailVC = EventDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
//            eventDetailVC.event = event
//            navigationController?.pushViewController(eventDetailVC, animated: true)
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 1
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 20
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if segmentedControl.selectedSegmentIndex == 0 {
            return 1
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return 20
        }
        return 1
    }

}
