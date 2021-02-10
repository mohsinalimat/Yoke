//
//  SearchFilterVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

protocol SearchFilterDelegate {
    func searchFilterController(_ searchFilterController: SearchFilterVC, didSaveSearch rating: Double, location: String, cusine: String, date: String, chefType: String)
}

class SearchFilterVC: UIViewController, FloatRatingViewDelegate {
    
    var delegate: SearchFilterDelegate?
    
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
        setupNavTitleAndBarButtonItems()
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Filter"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(handleDismiss))
//        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
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
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "Delete"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
//        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    func setupViews() {
        
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        view.addSubview(searchButton)
        searchButton.anchor(top: navView.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(ratingLabel)
        ratingLabel.anchor(top:navView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        view.addSubview(ratingView)
        ratingView.anchor(top: navView.bottomAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 150, height: 25)
        
        view.addSubview(cusineField)
        cusineField.anchor(top: ratingView.bottomAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 150, height: 25)
        
        view.addSubview(cusineLabel)
        cusineLabel.anchor(top: cusineField.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        view.addSubview(locationField)
        locationField.anchor(top: cusineField.bottomAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 150, height: 25)
        
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
            
            if professionalSwitch.isOn {
//                proChef = Constants.Professional
//                del.searchFilterController(self, didSaveSearch: ratingCount!, location: locationName!, cusine: cusineType!, date: filteredDate, chefType: proChef!)
//            } else if homeSwitch.isOn {
//                homeChef = Constants.Home
//                del.searchFilterController(self, didSaveSearch: ratingCount!, location: locationName!, cusine: cusineType!, date: filteredDate, chefType: homeChef!)
//            } else {
//                del.searchFilterController(self, didSaveSearch: ratingCount!, location: locationName!, cusine: cusineType!, date: filteredDate, chefType: "")
            }
        }
    }

}
