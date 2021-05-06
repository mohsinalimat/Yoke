//
//  PaymentViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/15/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let noCellId = "noCellId"
    let cellId = "cellId"
    let cellId2 = "cellId2"
    let cellId3 = "cellId3"
    
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
        configureNavigationBar(withTitle: "Payments", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(scrollView)
        scrollView.addSubview(paymentHeaderViews)
        scrollView.addSubview(paymentHeaderLabel)
        scrollView.addSubview(pendingAmountLabel)
        
    }
    
    func constrainViews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        paymentHeaderViews.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 50, paddingRight: 10, height: 200)
        paymentHeaderLabel.anchor(top: paymentHeaderViews.topAnchor, left: paymentHeaderViews.leftAnchor, bottom: nil, right: paymentHeaderViews.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        pendingAmountLabel.anchor(top: paymentHeaderLabel.bottomAnchor, left: paymentHeaderViews.leftAnchor, bottom: nil, right: paymentHeaderViews.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        
    }
    
    func setupCollectionViews() {
        todaysCollectionView.backgroundColor = UIColor.clear
        todaysCollectionView.delegate = self
        todaysCollectionView.dataSource = self
        todaysCollectionView.translatesAutoresizingMaskIntoConstraints = false
        todaysCollectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        todaysCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        
        pendingCollectionView.backgroundColor = UIColor.clear
        pendingCollectionView.delegate = self
        pendingCollectionView.dataSource = self
        pendingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        pendingCollectionView.register(BookingsCollectionViewCell.self, forCellWithReuseIdentifier: cellId2)
        pendingCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        pendingCollectionView.isHidden = false
        
        archivedCollectionView.backgroundColor = UIColor.clear
        archivedCollectionView.delegate = self
        archivedCollectionView.dataSource = self
        archivedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        archivedCollectionView.register(BookingsCollectionViewCell.self, forCellWithReuseIdentifier: cellId3)
        archivedCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        archivedCollectionView.isHidden = true
    }
    
    //MARK: - Selectors
    @objc func handleSegSelection(index: Int) {
        if segmentedControl.selectedSegmentIndex == 0 {
            archivedCollectionView.isHidden = true
            pendingCollectionView.isHidden = false
        } else if segmentedControl.selectedSegmentIndex == 1 {
            pendingCollectionView.isHidden = true
            archivedCollectionView.isHidden = false
        }
    }
    
    //MARK: - Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let paymentHeaderViews: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let paymentHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Pending Balance"
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    let pendingAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "$127.99"
        label.textColor = UIColor.gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22)
        return label
    }()
    
    var viewAllTodayButton: UIButton = {
        let button = UIButton()
        button.setTitle("View all", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    let todaysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let upcomingArchivedViews: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let segmentShadowView: ShadowView = {
        let view = ShadowView()
        return view
    }()
    
    let segmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Pending", "Paid"])
        seg.selectedSegmentIndex = 0
        seg.layer.cornerRadius = 10
        seg.layer.borderWidth = 0.5
        seg.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        let image = UIImage(named: "whiteBG")
        seg.setBackgroundImage(image, for: .normal, barMetrics: .default)
        seg.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.orangeColor()!], for: UIControl.State.selected)
        seg.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.5)], for: UIControl.State.normal)
        seg.addTarget(self, action: #selector(handleSegSelection), for: .valueChanged)
        return seg
    }()
    
    let pendingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    let archivedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
}

// MARK: - CollectionView
extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.todaysCollectionView {
            return 2
        }
        if collectionView == self.pendingCollectionView {
            return 1
        }
        if collectionView == self.archivedCollectionView {
            return 3
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.todaysCollectionView {
//            if MenuController.shared.menus.count == 0 {
//                let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
//                noCell.noPostLabel.text = "Hey chef, Add a menu to your profile."
//                noCell.noPostLabel.font = UIFont.boldSystemFont(ofSize: 15)
//                return noCell
//            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCollectionViewCell
    //        cell.review = ReviewController.shared.reviews[indexPath.item]
            return cell
        }
        if collectionView == self.pendingCollectionView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! BookingsCollectionViewCell
            return cellA
        }
        let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! BookingsCollectionViewCell
        return cellB
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.todaysCollectionView {
            return CGSize(width: view.frame.width - 75, height: 150)
        }
        return CGSize(width: view.frame.width - 25, height: 150)
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
