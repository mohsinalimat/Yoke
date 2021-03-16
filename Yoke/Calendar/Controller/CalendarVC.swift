//
//  CalendarVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import JTAppleCalendar

//https://www.raywenderlich.com/10787749-creating-a-custom-calendar-control-for-ios

class CalendarVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var user: User?
    var userId: String?
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
        }

    }
    
    let noCellId = "noCellId"
    let cellId = "cellId"
    let scheduleCell = "scheduleCell"
    var scheduleView: UICollectionView!
    var searchController : UISearchController!
    let calendarView = JTAppleCalendarView()
    var testCalendar = Calendar.current
    let formatter = DateFormatter()
    var visibleDate: Date?
    var selectedDate: Date?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(handleFetchAll), name: EditScheduleVC.updateNotificationName, object: nil)
        
        setupNavTitleAndBarButtonItems()
        fetchUser()
        setupCalendarViews()
        setupViews()
        showTodayWithAnimate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.black
    }
    
    @objc func handleFetchAll() {
        fetchAllSchedules()
        schedules.removeAll()
        scheduleView?.reloadData()
        calendarView.reloadData()
        self.todayButton.backgroundColor = UIColor.orangeColor()
        self.allButton.backgroundColor = UIColor.yellowColor()
//        self.upcommingButton.backgroundColor = UIColor.mainColor()
    }
    
    @objc func handleFetchUpcomming() {
        fetchUpcommingSchedules()
        schedules.removeAll()
        scheduleView?.reloadData()
        calendarView.reloadData()
        self.todayButton.backgroundColor = UIColor.orangeColor()
        self.allButton.backgroundColor = UIColor.orangeColor()
//        self.upcommingButton.backgroundColor = UIColor.secondaryColor()
    }

    
    @objc func showTodayWithAnimate() {
        showToday(animate: true)
    }
    
    func showToday(animate:Bool) {
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: animate, preferredScrollPosition: nil, extraAddedOffset: 0) { [unowned self] in
            self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
                self.setupViewsOfCalendar(from: visibleDates)
            }
            
            self.todayButton.backgroundColor = UIColor.yellowColor()
            self.allButton.backgroundColor = UIColor.orangeColor()
//            self.upcommingButton.backgroundColor = UIColor.mainColor()
            
            
            self.calendarView.selectDates([Date()])
            self.schedules.removeAll()
            self.scheduleView?.reloadData()
            self.calendarView.reloadData()
        }
    }
    
    fileprivate func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Schedule"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleNewDate))
    }
    
    @objc func handleNewDate() {
        let addEvent = AddUserVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(addEvent, animated: true)
    }
    
    //MARK: Blackout Dates Setup
    
    let selectDateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Please select date to set Availability", for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.layer.borderColor = UIColor.orangeColor()?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(dateButtonPressed), for: .touchUpInside)
        return button
    }()
    
    @objc func dateButtonPressed() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Available).child(uid)
        let makeKey = ref.childByAutoId().key
        
        self.formatter.dateFormat = "MMM d, yyyy"
        let selectedDates = self.formatter.string(from: self.selectedDate!)
        
        ref.queryOrdered(byChild: Constants.BlackoutDate).queryEqual(toValue: selectedDates).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                dictionaries.forEach({ (key, value) in
                    ref.child(key).removeValue(completionBlock: { (err, ref) in
                        if let err = err {
                            print("failed to make date available", err)
                            return
                        }
                    })
                })
            } else {
                self.formatter.dateFormat = "MMM d, yyyy"
                let selectedDates = self.formatter.string(from: self.selectedDate!)
                let values = [Constants.BlackoutDate: selectedDates, Constants.Uid: uid] as [String : Any]
                ref.child(makeKey!).updateChildValues(values) { (err, ref) in
                    if let err = err {
                        print("failed to block date", err)
                        return
                    }
                }
            }
        }
        DispatchQueue.main.async {
//            self.calendarView.reloadData()
            self.myBlackDates.removeAll()
        }
    }
    
    //MARK: Schedule View
    
    let todayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Today", for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(showTodayWithAnimate), for: .touchUpInside)
        button.layer.cornerRadius = 2
        return button
    }()
    
    let allButton: UIButton = {
        let button = UIButton()
        button.setTitle("All", for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleFetchAll), for: .touchUpInside)
        return button
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupCalendarViews() {
        
        view.addSubview(monthLabel)
        monthLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(yearLabel)
        yearLabel.anchor(top: view.topAnchor, left: monthLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(weekdayView)
        weekdayView.anchor(top: monthLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.scrollDirection = .horizontal
        calendarView.allowsMultipleSelection = false
        calendarView.allowsSelection = true
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        
        calendarView.backgroundColor = UIColor.white
        
        view.addSubview(calendarView)
        calendarView.anchor(top: weekdayView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 270)
        
        calendarView.minimumLineSpacing = -1
        calendarView.minimumInteritemSpacing = -1
        
        calendarView.scrollToDate(Date())
        calendarView.register(DateCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    func setupViews() {
        
        view.addSubview(selectDateButton)
        selectDateButton.anchor(top: calendarView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 32)
        
        let stackView = UIStackView(arrangedSubviews: [todayButton, allButton])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        view.addSubview(stackView)

        stackView.anchor(top: selectDateButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 32)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        scheduleView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        scheduleView.delegate   = self
        scheduleView.dataSource = self
        scheduleView.register(ScheduleCell.self, forCellWithReuseIdentifier: scheduleCell)
        scheduleView.register(EmptyCell.self, forCellWithReuseIdentifier: noCellId)
        scheduleView.backgroundColor = UIColor.white
        scheduleView.alwaysBounceVertical = true
        
        
        self.view.addSubview(scheduleView)
        scheduleView.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 0)
        
    }
    
    //MARK: Fetch users schedule
    var schedules = [Schedule]()
    func fetchAllSchedules() {
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).queryOrdered(byChild: Constants.Uid).queryEqual(toValue: currentUser)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let schedule = Schedule(user: user, dictionary: dictionary, snapshot: snapshot)

            self.schedules.append(schedule)
            self.schedules.sort(by: { (schedule1, schedule2) -> Bool in
                return schedule1.scheduleDate.compare(schedule2.scheduleDate) == .orderedAscending
            })
            self.scheduleView.reloadData()
            
        }) { (err) in
            print("failed to fetch schedule")
        }
    }
    
    func fetchUpcommingSchedules() {
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).queryOrdered(byChild: Constants.Uid).queryEqual(toValue: currentUser)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let schedule = Schedule(user: user, dictionary: dictionary, snapshot: snapshot)
//            let scheduleDate = self.formatter.string(from: schedule.scheduleDate)
            let getSchedule = schedule.scheduleDate
            let todaysDate = self.formatter.string(from: Date())
            
            if getSchedule == todaysDate || getSchedule > todaysDate {
                self.schedules.append(schedule)
                self.schedules.sort(by: { (schedule1, schedule2) -> Bool in
                    return schedule1.scheduleDate.compare(schedule2.scheduleDate) == .orderedAscending
                })
                self.scheduleView.reloadData()
            } else {
                return
            }
            
        }) { (err) in
            print("failed to fetch schedule")
        }
    }
    
    func fetchSelectedSchedules(date: Date) {
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).queryOrdered(byChild: Constants.Uid).queryEqual(toValue: currentUser)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let schedule = Schedule(user: user, dictionary: dictionary, snapshot: snapshot)
            let getSchedule = schedule.scheduleDate
            let selectedDates = self.formatter.string(from: date)
            let equalDates = getSchedule == selectedDates
            if equalDates == true {
                self.schedules.append(schedule)
                self.schedules.sort(by: { (schedule1, schedule2) -> Bool in
                    return schedule1.scheduleDate.compare(schedule2.scheduleDate) == .orderedAscending
                })
            }
            self.scheduleView.reloadData()
            
        }) { (err) in
            print("failed to fetch schedule")
        }
    
    }
    
    @objc func getCalendarSegments(index: Int) {
        scheduleView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if schedules.count == 0 {
            return 1
        } else {
            return schedules.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if schedules.count == 0 {
            let noCell = collectionView.dequeueReusableCell(withReuseIdentifier: noCellId, for: indexPath) as! EmptyCell
            noCell.noPostLabel.text = "You have nothing scheduled"
            return noCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: scheduleCell, for: indexPath) as! ScheduleCell
        cell.schedule = schedules[indexPath.item]
        
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = 0.2
        cell.layer.borderColor = UIColor.lightGray.cgColor

        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 0.3
        cell.layer.masksToBounds = false
        
        return cell
    }
    
    var events = [Event]()
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let schedule = self.schedules[indexPath.row]
        
        let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule)
        ref.child(schedule.key).observe(.value, with: { (snapshot) in
            
            if snapshot.hasChild(Constants.Event) {
                let eventRef = Database.database().reference().child(Constants.Event).child(schedule.eventKey)
                eventRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    print("in event \(schedule.eventKey)")
                    guard let dictionary = snapshot.value as? [String: Any] else {return}
                    guard let uid = dictionary[Constants.Uid] as? String else {return}
                    
                    Database.fetchUserWithUID(uid: uid, completion: { (user) in
                        let event = Event(user: user, dictionary: dictionary, snapshot: snapshot)
                        self.events.append(event)
                        let eventDetailVC = EventDetailVC(collectionViewLayout: UICollectionViewFlowLayout())
                        eventDetailVC.event = event
                        self.navigationController?.pushViewController(eventDetailVC, animated: true)
                    })
                })
                
                
            } else {
                let editScheduleVC = EditScheduleVC()
                editScheduleVC.schedule = schedule
                self.navigationController?.pushViewController(editScheduleVC, animated: true)

            }
            
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: view.frame.width - 15, height: 70)
    }
    
    //MARK: Calendar Functions
    
    @objc func editEvent(sender: UIButton){
        guard let currentUserId = Auth.auth().currentUser?.uid else {return}
        
        let alertController = UIAlertController(title: "Are you sure you want to delete?", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        alertController.addAction(cancelAction)
        
        let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            let item = sender.tag
            let indexPath = IndexPath(item: item, section: 0)
            let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule)
            ref.child(self.schedules[indexPath.item].key!).observe(.value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                let eventKey = dictionary[Constants.Event]
                Database.database().reference().child(Constants.Calendar).child(Constants.BookmarkedEvents).child(currentUserId).child(eventKey as! String).removeValue()
                
            })
            
            ref.child(self.schedules[indexPath.item].key!).removeValue()
//            self.schedules.remove(at: item)
            self.schedules.remove(at: indexPath.item)
            self.scheduleView?.reloadData()
            self.calendarView.reloadData()
        }

        
        alertController.addAction(destroyAction)
//        alertController.addAction(editAction)
        self.present(alertController, animated: true) {
        }
    }
    
    //MARK: Calendar Setup and Views
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.black.cgColor
        return view
    }()
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weekdayView: WeekdaysView = {
        let view = WeekdaysView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.mainColor()
        return view
    }()
    
    func setupViewsOfCalendar( from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {return}
        self.formatter.dateFormat = "yyyy"
        self.yearLabel.text = formatter.string(from: startDate)

        self.formatter.dateFormat = "MMMM"
        self.monthLabel.text = formatter.string(from: startDate)
    }
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? DateCell else { return }
        
        myCustomCell.layer.borderWidth = 1
        myCustomCell.layer.borderColor = UIColor.white.cgColor
        
        myCustomCell.dayLabel.text = cellState.text
        
        handelCellBlackoutDates(view: myCustomCell, cellState: cellState)
        handleEvents(view: myCustomCell, cellState: cellState)
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
    }
    
    func handleCellSelection(view: DateCell, cellState: CellState) {
        view.selectedView.isHidden = !cellState.isSelected
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? DateCell  else {return}
       
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = UIColor.white
            myCustomCell.backgroundColor = UIColor.clear
            myCustomCell.eventView.backgroundColor = UIColor.white
        }
        else {
            myCustomCell.dayLabel.textColor = UIColor.darkGray
            myCustomCell.eventView.backgroundColor = UIColor.yellowColor()
        }
        
        if cellState.dateBelongsTo != .thisMonth {
            myCustomCell.dayLabel.textColor = UIColor.clear
        }
        
        if Calendar.current.isDateInToday(cellState.date) {
            if cellState.isSelected {
                myCustomCell.dayLabel.textColor = UIColor.white
                myCustomCell.selectedView.isHidden = false
            }
            else {
                myCustomCell.dayLabel.textColor = UIColor.yellowColor()
                myCustomCell.selectedView.isHidden = true
            }
        }
    }
    
    var myBlackDates: Set<String> = []
    func handelCellBlackoutDates(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? DateCell else { return }
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Available).child(uid)
        ref.observe(.value) { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                
                ref.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = value as? [String: Any] else { return }
                    let blackoutDate = dictionary[Constants.BlackoutDate] as? String
                    self.formatter.dateFormat = "MMM d, yyyy"
                    let selectedDates = self.formatter.string(from: cellState.date)
                    self.myBlackDates.insert(blackoutDate!)
                    
                    if self.myBlackDates.contains(selectedDates) && cellState.dateBelongsTo == .thisMonth {
                        myCustomCell.blackoutView.isHidden = false
                        self.selectDateButton.setTitle("Make as Available", for: .normal)
                        self.selectDateButton.backgroundColor = UIColor.orangeColor()
                        self.selectDateButton.setTitleColor(UIColor.white, for: .normal)
                    } else {
                        myCustomCell.blackoutView.isHidden = true
                        self.selectDateButton.setTitle("Mark as Unavailable", for: .normal)
                        self.selectDateButton.backgroundColor = UIColor.white
                        self.selectDateButton.setTitleColor(UIColor.orangeColor(), for: .normal)
                    }
                    
                })
                
            })
            
        }
    }
    
    var myDataSource: Set<String> = []
    func handleEvents(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCell else {return}
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).queryOrdered(byChild: Constants.Uid).queryEqual(toValue: currentUser)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let user = self.user else { return }
            let schedule = Schedule(user: user, dictionary: dictionary, snapshot: snapshot)
            let getSchedule = schedule.scheduleDate
            self.formatter.dateFormat = "MMM d, yyyy"
            let selectedDates = self.formatter.string(from: cellState.date)
            self.myDataSource.insert(getSchedule)
            if self.myDataSource.contains(selectedDates) && cellState.dateBelongsTo == .thisMonth {
                cell.eventView.isHidden = false
            } else {
                cell.eventView.isHidden = true
            }
            
        }) { (err) in
            print("failed to fetch schedule")
        }
    }
 
}

extension CalendarVC: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2025 01 01")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: testCalendar, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday)
        return parameters
    }
    
}

extension CalendarVC: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCell
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellId, for: indexPath) as! DateCell
        cell.dayLabel.text = cellState.text
        configureCell(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        calendarView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        selectedDate = date
        fetchSelectedSchedules(date: selectedDate!)
        scheduleView.reloadData()
        schedules.removeAll()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
        calendarView.reloadData()
        schedules.removeAll()
    }
    
}




