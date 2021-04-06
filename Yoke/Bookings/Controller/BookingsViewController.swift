//
//  BookingsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/5/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class BookingsViewController: UIViewController {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let noCellId = "noCellId"
    let cellId = "cellId"
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Bookings", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
        let filterIcon = UIImage(named: "add-filled")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.image = filterIcon
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(handleNew))
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(scrollView)
        scrollView.addSubview(todaysViews)
        scrollView.addSubview(todayLabel)
        scrollView.addSubview(todaysCollectionView)
    }
    
    func constrainViews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        todaysViews.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 50, paddingRight: 10, height: 200)
        todayLabel.anchor(top: todaysViews.topAnchor, left: todaysViews.leftAnchor, bottom: nil, right: todaysViews.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10)
        todaysCollectionView.anchor(top: todayLabel.bottomAnchor, left: todaysViews.leftAnchor, bottom: nil, right: todaysViews.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 150)
    }
    
    func setupCollectionViews() {
        todaysCollectionView.backgroundColor = UIColor.clear
        todaysCollectionView.delegate = self
        todaysCollectionView.dataSource = self
        todaysCollectionView.translatesAutoresizingMaskIntoConstraints = false
        todaysCollectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        todaysCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
    }
    
    //MARK: - Selectors
    @objc func handleNew() {
        
    }
    
    //MARK: - Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let todaysViews: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Schedule"
        label.textColor = UIColor.orangeColor()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        return label
    }()
    
    let todaysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
}

// MARK: - CollectionView
extension BookingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
//        if collectionView == self.menuCollectionView {
//            if MenuController.shared.menus.count == 0 {
//                return 1
//            } else {
//                return MenuController.shared.menus.count
//            }
//        }
//        if SuggestedChefController.shared.chefs.count == 0 {
//            return 1
//        } else {
//            return SuggestedChefController.shared.chefs.count
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.menuCollectionView {
//            if MenuController.shared.menus.count == 0 {
//                let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
//                noCell.noPostLabel.text = "Hey chef, Add a menu to your profile."
//                noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 15)
//                return noCell
//            }
//
//            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCollectionViewCell
//            cellA.menu = MenuController.shared.menus[indexPath.item]
//            return cellA
//        }
        
//        let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SuggestedChefsCollectionViewCell
//        if SuggestedChefController.shared.chefs.count == 0 {
//            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
//            noCell.noPostLabel.text = "Sorry, there are currently no chefs in your area"
//            noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 15)
//            return noCell
//        } else {
//            cellB.chef = SuggestedChefController.shared.chefs[indexPath.item]
//            return cellB
//        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCollectionViewCell
//        cell.review = ReviewController.shared.reviews[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.menuCollectionView {
//            if MenuController.shared.menus.count == 0 {
//                return CGSize(width: view.frame.width - 20, height: 100)
//            } else {
//                return CGSize(width: view.frame.width - 20, height: 180)
//            }
//        }
//
//        if SuggestedChefController.shared.chefs.count == 0 {
//            return CGSize(width: view.frame.width - 20, height: 100)
//        } else {
//            return CGSize(width: view.frame.width - 130, height: 90)
//        }
        return CGSize(width: view.frame.width - 75, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if collectionView == self.menuCollectionView {
//            if MenuController.shared.menus.count == 0 {
//                return
//            } else {
//                let menu = MenuController.shared.menus[indexPath.row]
//                let menuVC = AddMenuViewController()
//                menuVC.menu = menu
//                menuVC.menuLabel.text = "Edit Menu"
//                menuVC.dishDetailTextField.placeholder = ""
//                menuVC.deleteButton.isHidden = false
//                menuVC.menuExist = true
//                menuVC.saveButton.setTitle("Update", for: .normal)
//                present(menuVC, animated: true)
//            }
//        } else {
//            if SuggestedChefController.shared.chefs.count == 0 {
//                return
//            } else {
//                let chef = SuggestedChefController.shared.chefs[indexPath.row].uid
//                let profileVC = ProfileViewController()
//                profileVC.userId = chef
//                navigationController?.pushViewController(profileVC, animated: true)
//            }
//        }
    }
}
