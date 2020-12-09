//
//  EventsFilterVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol SearchEventsFilterDelegate {
    func searchEventsFilterController(_ searchFilterController: EventsFilterVC, didSaveSearch location: String, cusine: String, date: String, chefType: String)
}

class EventsFilterVC: UIViewController, FloatRatingViewDelegate {
    
    var delegate: SearchEventsFilterDelegate?
    
    let calendarView = JTAppleCalendarView()
    var testCalendar = Calendar.current
    let formatter = DateFormatter()
    var visibleDate: Date?
    var selectedDate: Date?
    let cellId = "cellId"
    
    var ratingCount: Double?
    var locationName: String?
    var cusineType: String?
    var proChef: String?
    var homeChef: String?
    var filteredDate: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        ratingView.delegate = self
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        ratingView.type = .wholeRatings
        
        setupViews()
        setupCalendarViews()
        setupNavTitleAndBarButtonItems()
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Filter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(handleDismiss))
        //        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
    var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Select rating"
        return label
    }()
    
    lazy var ratingView: RatingView = {
        let view = RatingView()
        view.backgroundColor = .clear
        view.minRating = 0
        view.maxRating = 5
        view.rating = 0
        view.editable = true
        view.emptyImage = UIImage(named: "StarEmptyBlack")
        view.fullImage = UIImage(named: "StarFullBlack")
        return view
    }()
    
    var cusineLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Select Cusine"
        return label
    }()
    
    let cusineField: UITextField = {
        let textView = UITextField()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.textAlignment = .justified
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        return textView
    }()
    
    var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Select Location"
        return label
    }()
    
    let locationField: UITextField = {
        let textView = UITextField()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.textAlignment = .justified
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        return textView
    }()
    
    var professioanlLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Professioanl chefs only?"
        return label
    }()
    
    var professionalSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.black
        switchBool.onTintColor = UIColor.black
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(proSwitch(proSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Select a date"
        return label
    }()
    
    func getSelectedDate(date: Date) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy"
        let selectedDate: String = dateFormatter.string(from: date)
        dateLabel.text = "\(selectedDate)"
    }
    
    let dateView: UITextField = {
        let text = UITextField()
        text.text = "Event Date:"
        text.textColor = UIColor.black
        return text
    }()
    
    @objc func proSwitch(proSwitchChanged: UISwitch) {
        homeSwitch.setOn(false, animated: true)
    }
    
    var homeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Home chefs only?"
        return label
    }()
    
    var homeSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.tintColor = UIColor.black
        switchBool.onTintColor = UIColor.black
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(homeSwitch(homeSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    @objc func homeSwitch(homeSwitchChanged: UISwitch) {
        professionalSwitch.setOn(false, animated: true)
    }
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "Delete"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        view.addSubview(saveButton)
        saveButton.anchor(top: navView.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(cusineField)
        cusineField.anchor(top: navView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 150, height: 25)
        
        view.addSubview(cusineLabel)
        cusineLabel.anchor(top: cusineField.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        view.addSubview(locationField)
        locationField.anchor(top: cusineField.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 150, height: 25)
        
        view.addSubview(locationLabel)
        locationLabel.anchor(top: locationField.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        view.addSubview(professionalSwitch)
        professionalSwitch.anchor(top: locationField.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 25)
        
        view.addSubview(professioanlLabel)
        professioanlLabel.anchor(top: professionalSwitch.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 25)
        
        view.addSubview(homeSwitch)
        homeSwitch.anchor(top: professionalSwitch.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 25)
        
        view.addSubview(homeLabel)
        homeLabel.anchor(top: homeSwitch.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 25)
        
        view.addSubview(dateView)
        dateView.anchor(top: homeLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 100, height: 25)
        
        view.addSubview(dateLabel)
        dateLabel.anchor(top: dateView.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 25)
        
    }
    
    @objc func handleSave() {
        if delegate != nil {
            ratingCount = self.ratingView.rating
            cusineType = cusineField.text
            locationName = locationField.text
            
            if selectedDate == nil {
                filteredDate = ""
            } else {
                let dateFormatter: DateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy MM dd"
                filteredDate = dateFormatter.string(from: selectedDate!)
            }

            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let monthLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    let weekdayView: WeekdaysView = {
        let view = WeekdaysView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupCalendarViews() {
        view.addSubview(monthLabel)
        monthLabel.anchor(top: dateLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        view.addSubview(yearLabel)
        yearLabel.anchor(top: monthLabel.topAnchor, left: monthLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        view.addSubview(weekdayView)
        weekdayView.anchor(top: monthLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.scrollDirection = .horizontal
        calendarView.allowsMultipleSelection = false
        calendarView.allowsSelection = true
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        
        calendarView.backgroundColor = UIColor.white
        
        view.addSubview(calendarView)
        calendarView.anchor(top: weekdayView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        
        calendarView.minimumLineSpacing = -1
        calendarView.minimumInteritemSpacing = -1
        
        
        calendarView.scrollToDate(Date())
        calendarView.register(DateCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
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
        myCustomCell.backgroundColor = UIColor.orangeColor()
        
        myCustomCell.dayLabel.text = cellState.text
        let cellHidden = cellState.dateBelongsTo != .thisMonth
        
        myCustomCell.isHidden = cellHidden
        
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
    }
    
    func handleCellSelection(view: DateCell, cellState: CellState) {
        view.selectedView.isHidden = !cellState.isSelected
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let myCustomCell = view as? DateCell  else {return}
        
        if cellState.isSelected {
            myCustomCell.dayLabel.textColor = UIColor.black
            myCustomCell.backgroundColor = UIColor.clear
            myCustomCell.todayView.isHidden = true
        }
        else {
            myCustomCell.dayLabel.textColor = UIColor.white
            myCustomCell.todayView.isHidden = true
        }
        
        if Calendar.current.isDateInToday(cellState.date) {
            if cellState.isSelected {
                myCustomCell.dayLabel.textColor = UIColor.black
                myCustomCell.selectedView.isHidden = false
                myCustomCell.todayView.isHidden = true
            }
            else {
                myCustomCell.dayLabel.textColor = UIColor.orangeColor()
                myCustomCell.selectedView.isHidden = true
                myCustomCell.todayView.isHidden = false
            }
        }
    }
    
}

extension EventsFilterVC: JTAppleCalendarViewDataSource {
    
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

extension EventsFilterVC: JTAppleCalendarViewDelegate {
    
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
        selectedDate = date
        getSelectedDate(date: date)
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(view: cell, cellState: cellState)
    }
    
}
