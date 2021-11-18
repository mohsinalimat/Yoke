//
//  BookingsViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/5/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class BookingsViewController: UIViewController {
    
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
        fetchTodaysBookings()
        fetchUpcomingBookings()
        fetchArchivesBookings()
    }
    
    //MARK: - Helper Functions
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Bookings", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(scrollView)
        scrollView.addSubview(todaysViews)
        scrollView.addSubview(todayLabel)
        scrollView.addSubview(todaysCollectionView)
        scrollView.addSubview(upcomingArchivedViews)
        scrollView.addSubview(segmentShadowView)
        scrollView.addSubview(bookingSegmentedControl)
        scrollView.addSubview(upcomingCollectionView)
        scrollView.addSubview(archivedCollectionView)
    }
    
    func constrainViews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        todaysViews.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 50, paddingRight: 10, height: 200)
        todayLabel.anchor(top: todaysViews.topAnchor, left: todaysViews.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        todaysCollectionView.anchor(top: todayLabel.bottomAnchor, left: todaysViews.leftAnchor, bottom: nil, right: todaysViews.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 150)
        upcomingArchivedViews.anchor(top: todaysViews.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        segmentShadowView.anchor(top: upcomingArchivedViews.topAnchor, left: upcomingArchivedViews.leftAnchor, bottom: nil, right: upcomingArchivedViews.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 45)
        bookingSegmentedControl.anchor(top: upcomingArchivedViews.topAnchor, left: upcomingArchivedViews.leftAnchor, bottom: nil, right: upcomingArchivedViews.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 45)
        upcomingCollectionView.anchor(top: bookingSegmentedControl.bottomAnchor, left: upcomingArchivedViews.leftAnchor, bottom: upcomingArchivedViews.bottomAnchor, right: upcomingArchivedViews.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        archivedCollectionView.anchor(top: bookingSegmentedControl.bottomAnchor, left: upcomingArchivedViews.leftAnchor, bottom: upcomingArchivedViews.bottomAnchor, right: upcomingArchivedViews.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func setupCollectionViews() {
        todaysCollectionView.backgroundColor = UIColor.clear
        todaysCollectionView.delegate = self
        todaysCollectionView.dataSource = self
        todaysCollectionView.translatesAutoresizingMaskIntoConstraints = false
        todaysCollectionView.register(TodayCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        todaysCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        
        upcomingCollectionView.backgroundColor = UIColor.clear
        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self
        upcomingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        upcomingCollectionView.register(BookingsCollectionViewCell.self, forCellWithReuseIdentifier: cellId2)
        upcomingCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        upcomingCollectionView.isHidden = false
        
        archivedCollectionView.backgroundColor = UIColor.clear
        archivedCollectionView.delegate = self
        archivedCollectionView.dataSource = self
        archivedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        archivedCollectionView.register(BookingsCollectionViewCell.self, forCellWithReuseIdentifier: cellId3)
        archivedCollectionView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        archivedCollectionView.isHidden = true
    }
    
    func fetchTodaysBookings() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        BookingController.shared.fetchTodaysBookingsWith(uid: uid) { result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.todaysCollectionView.reloadData()
                }
            case false:
                print("No bookings today")
            }
        }
    }
    
    func fetchUpcomingBookings() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        BookingController.shared.fetchUpcomingBookingsWith(uid: uid) { result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.upcomingCollectionView.reloadData()
                }
            case false:
                print("No upcoming bookings")
            }
        }
    }
    
    func fetchArchivesBookings() {
        let uid = Auth.auth().currentUser?.uid ?? ""
        BookingController.shared.fetchArchivesWith(uid: uid) { result in
            switch result {
            case true:
                DispatchQueue.main.async {
                    self.archivedCollectionView.reloadData()
                }
            case false:
                print("No upcoming bookings")
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleSegSelection(index: Int) {
        if bookingSegmentedControl.selectedSegmentIndex == 0 {
            archivedCollectionView.isHidden = true
            upcomingCollectionView.isHidden = false
        } else if bookingSegmentedControl.selectedSegmentIndex == 1 {
            upcomingCollectionView.isHidden = true
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
    
    let upcomingArchivedViews: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let segmentShadowView: ShadowView = {
        let view = ShadowView()
        return view
    }()
    
    let bookingSegmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Upcoming", "Archived"])
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
    
    let upcomingCollectionView: UICollectionView = {
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
extension BookingsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.todaysCollectionView {
            return BookingController.shared.todaysBookings.count
        }
        if collectionView == self.upcomingCollectionView {
            print(BookingController.shared.upComingBookings.count)
            return BookingController.shared.upComingBookings.count
        }
        if collectionView == self.archivedCollectionView {
            return BookingController.shared.archives.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.todaysCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TodayCollectionViewCell
            cell.booking = BookingController.shared.todaysBookings[indexPath.row]
            return cell
        }
        if collectionView == self.upcomingCollectionView {
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: cellId2, for: indexPath) as! BookingsCollectionViewCell
            cellA.booking = BookingController.shared.upComingBookings[indexPath.row]
            return cellA
        }
        let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! BookingsCollectionViewCell
        cellB.booking = BookingController.shared.archives[indexPath.row]
        return cellB
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.todaysCollectionView {
            return CGSize(width: view.frame.width - 75, height: 150)
        }
        return CGSize(width: view.frame.width - 25, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.todaysCollectionView {
            let booking = BookingController.shared.todaysBookings[indexPath.row]
            let bookingVC = BookingRequestDetailViewController()
            bookingVC.booking = booking
            navigationController?.pushViewController(bookingVC, animated: true)
        }
        if collectionView == self.upcomingCollectionView {
            let booking = BookingController.shared.upComingBookings[indexPath.row]
            let bookingVC = BookingRequestDetailViewController()
            bookingVC.booking = booking
            navigationController?.pushViewController(bookingVC, animated: true)
        }
        
        if collectionView == self.archivedCollectionView {
            let booking = BookingController.shared.archives[indexPath.row]
            let bookingVC = BookingRequestDetailViewController()
            bookingVC.booking = booking
            navigationController?.pushViewController(bookingVC, animated: true)
        }
    }
}
