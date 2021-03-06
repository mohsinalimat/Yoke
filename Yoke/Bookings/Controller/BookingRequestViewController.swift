//
//  BookingRequestViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 4/8/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class BookingRequestViewController: UIViewController, BookingLocationDelegate {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    var currentUserUid = Auth.auth().currentUser?.uid ?? ""
    var userId: String?
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var selectedLocation: String = ""
    var selectedDate : String = ""
    var selectedDatePicker = Date()
    var selectedStartTime: String = ""
    var selectedEndTime: String = ""
    var selectedLocationShort: String = ""
    var peopleCounter: Int = 1
    var courseCounter: Int = 1
//    var timestamp = (Any).self
    
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
        setupPickerViews()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(scrollView)
        scrollView.addSubview(introLabel)
        scrollView.addSubview(peopleCountViewBG)
        scrollView.addSubview(numberOfPeopleLabel)
        scrollView.addSubview(peopleCountStackView)
        peopleCountStackView.addArrangedSubview(peopleCountMinusButton)
        peopleCountStackView.addArrangedSubview(peopleCountTextField)
        peopleCountStackView.addArrangedSubview(peopleCountPlusButton)
        scrollView.addSubview(courseCountViewBG)
        scrollView.addSubview(numberOfCourseLabel)
        scrollView.addSubview(courseCountStackView)
        courseCountStackView.addArrangedSubview(courseCountMinusButton)
        courseCountStackView.addArrangedSubview(courseCountTextField)
        courseCountStackView.addArrangedSubview(courseCountPlusButton)
        scrollView.addSubview(cuisineView)
        scrollView.addSubview(cuisineTextField)
        scrollView.addSubview(locationViewBG)
        scrollView.addSubview(locationIndicatorIconView)
        scrollView.addSubview(locationButton)
        scrollView.addSubview(datePickerViewBG)
        scrollView.addSubview(selectedDateLabel)
        scrollView.addSubview(datePickerView)
        scrollView.addSubview(timeLabelStackView)
        timeLabelStackView.addArrangedSubview(startLabel)
        timeLabelStackView.addArrangedSubview(endLabel)
        scrollView.addSubview(timePickerViewBG)
        scrollView.addSubview(timeStackView)
        timeStackView.addArrangedSubview(startTimeTextField)
        timeStackView.addArrangedSubview(endTimeTextField)
        scrollView.addSubview(detailView)
        scrollView.addSubview(detailTextField)
        scrollView.addSubview(submitButton)
        view.addSubview(myActivityIndicator)
    }
    
    func constrainViews() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 600)
        scrollView.anchor(top: safeArea.topAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        introLabel.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 60)
        peopleCountViewBG.anchor(top: introLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 50)
        numberOfPeopleLabel.anchor(top: peopleCountViewBG.topAnchor, left: peopleCountViewBG.leftAnchor, bottom: peopleCountViewBG.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        peopleCountStackView.anchor(top: nil, left: nil, bottom: nil, right: peopleCountViewBG.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 110, height: 30)
        peopleCountStackView.centerYAnchor.constraint(equalTo: numberOfPeopleLabel.centerYAnchor).isActive = true
        
        courseCountViewBG.anchor(top: peopleCountViewBG.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 50)
        numberOfCourseLabel.anchor(top: courseCountViewBG.topAnchor, left: courseCountViewBG.leftAnchor, bottom: courseCountViewBG.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        courseCountStackView.anchor(top: nil, left: nil, bottom: nil, right: courseCountViewBG.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 5, width: 110, height: 30)
        courseCountStackView.centerYAnchor.constraint(equalTo: numberOfCourseLabel.centerYAnchor).isActive = true
        cuisineView.anchor(top: courseCountViewBG.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 50)
        cuisineTextField.anchor(top: nil, left: cuisineView.leftAnchor, bottom: nil, right: cuisineView.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        cuisineTextField.centerYAnchor.constraint(equalTo: cuisineView.centerYAnchor).isActive = true
        
        locationViewBG.anchor(top: cuisineView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
        locationButton.anchor(top: locationViewBG.topAnchor, left: locationViewBG.leftAnchor, bottom: locationViewBG.bottomAnchor, right: locationIndicatorIconView.leftAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0)
        locationIndicatorIconView.anchor(top: nil, left: locationButton.rightAnchor, bottom: nil, right: locationViewBG.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 20, height: 20)
        locationIndicatorIconView.centerYAnchor.constraint(equalTo: locationViewBG.centerYAnchor).isActive = true
        datePickerViewBG.anchor(top: locationButton.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 410)
        selectedDateLabel.anchor(top: datePickerViewBG.topAnchor, left: datePickerViewBG.leftAnchor, bottom: nil, right: datePickerViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 50)
        datePickerView.anchor(top: selectedDateLabel.bottomAnchor, left: datePickerViewBG.leftAnchor, bottom: nil, right: datePickerViewBG.rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, height: 350)
        timeLabelStackView.anchor(top: datePickerView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 50)
        timePickerViewBG.anchor(top: timeLabelStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: -10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 55)
        timeStackView.anchor(top: timeLabelStackView.bottomAnchor, left: timeLabelStackView.leftAnchor, bottom: nil, right: timeLabelStackView.rightAnchor, paddingTop: -10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 50)
        timeStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        detailView.anchor(top: timeStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 300)
        detailTextField.anchor(top: detailView.topAnchor, left: detailView.leftAnchor, bottom: detailView.bottomAnchor, right: detailView.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 5)
        submitButton.anchor(top: detailView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 50)
        myActivityIndicator.center = view.center
    }
    
    func configureNavigationBar() {
        guard let orange = UIColor.orangeColor() else { return }
        configureNavigationBar(withTitle: "Request", largeTitle: true, backgroundColor: UIColor.white, titleColor: orange)
    }
    
    func setupPickerViews() {
        datePickerView.minimumDate = Date()
        startTimeTextField.inputView = startTimePickerView
        endTimeTextField.inputView = endTimePickerView
    }
    
    func sentSuccessful() {
        let alertVC = UIAlertController(title: "Success", message: "Your request has been sent!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool Beans", style: .default) { (_) in
            self.handleDismiss()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func sentFailed() {
        let alertVC = UIAlertController(title: "Failed", message: "Something went wrong, please try again.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func formFail(title: String, message: String) {
        let alertVC = UIAlertController(title: "Missing \(title)", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func bookingLocationController(_ bookingLocationController: BookingLocationViewController, didSelectLocation location: String, locationShort: String) {
        selectedLocation = location
        selectedLocationShort = locationShort
        locationButton.setTitle(location, for: .normal)
    }
    
    //MARK: - Selectors
    
    @objc func handleSubmit() {
        guard let cuisine = cuisineTextField.text else { return }
        guard !selectedLocation.isEmpty else { return formFail(title: "Location", message: "Please select a location")}
        guard !selectedDate.isEmpty else { return formFail(title: "Request date", message: "Please select a date")}
        guard !selectedStartTime.isEmpty else { return formFail(title: "Start time", message: "Please select a start time")}
        guard !selectedEndTime.isEmpty else { return formFail(title: "End time", message: "Please select an end time")}
        guard let detail = detailTextField.text, !detail.isEmpty else { return formFail(title: "Details", message: "Please add some details about the event so the chef can give you a better estimate")}
        guard let chefUid = userId else { return }
        myActivityIndicator.startAnimating()
        self.sentSuccessful()
        BookingController.shared.createBookingWith(chefUid: chefUid, userUid: currentUserUid, location: selectedLocation, locationShort: selectedLocationShort, date: selectedDate, startTime: selectedStartTime, endTime: selectedEndTime, numberOfPeople: peopleCounter, numberOfCourses: courseCounter, typeOfCuisine: cuisine, details: detail, timestamp: selectedDatePicker) { (result) in
            switch result {
            case true:
                self.myActivityIndicator.stopAnimating()
                self.sentSuccessful()
            case false:
                self.sentFailed()
            }
        }
    }
    
    @objc func handleAddLocation() {
        let chooseLocation = BookingLocationViewController()
        chooseLocation.delegate = self
        present(chooseLocation, animated: true)
    }
    
    @objc func handleDateSelection() {
        let datePicker = datePickerView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        selectedDateLabel.text = dateFormatter.string(from: datePicker.date)
        selectedDate = dateFormatter.string(from: datePicker.date)
        selectedDateLabel.font = UIFont.systemFont(ofSize: 17)
        selectedDatePicker = datePicker.date
//        timestamp = datePicker.date
    }
    
    @objc func handleStartSelection() {
        let startPicker = startTimePickerView
        let startTimeFormatter = DateFormatter()
        startTimeFormatter.timeStyle = .short
        startTimeTextField.text = startTimeFormatter.string(from: startPicker.date)
        selectedStartTime = startTimeFormatter.string(from: startPicker.date)
    }
    
    @objc func handleEndSelection() {
        let endPicker = endTimePickerView
        let endTimeFormatter = DateFormatter()
        endTimeFormatter.timeStyle = .short
        endTimeTextField.text = endTimeFormatter.string(from: endPicker.date)
        selectedEndTime = endTimeFormatter.string(from: endPicker.date)
    }
    
    @objc func handleDismiss() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func handleAddPeopleCount() {
        guard let addValue = Int(peopleCountTextField.text!) else { return }
        if addValue < 0 {
            print("You cannot add a value less then 1")
        }
        let newValue = addValue + 1
        peopleCountTextField.text = String(newValue)
        peopleCounter = newValue
    }
    
    @objc func handleMinusPeopleCount() {
        guard let minusValue = Int(peopleCountTextField.text!) else { return }
        if minusValue < 0 {
            print("You cannot add a value less then 1")
        } else if minusValue > 1 {
            let newValue = minusValue - 1
            peopleCountTextField.text = String(newValue)
            peopleCounter = newValue
        }
        
    }
    
    @objc func handleAddCourseCount() {
        guard let addValue = Int(courseCountTextField.text!) else { return }
        if addValue < 0 {
            print("You cannot add a value less then 1")
        }
        let newValue = addValue + 1
        courseCountTextField.text = String(newValue)
        courseCounter = newValue
    }
    
    @objc func handleMinusCourseCount() {
        guard let minusValue = Int(courseCountTextField.text!) else { return }
        if minusValue < 0 {
            print("You cannot add a value less then 1")
        } else if minusValue > 1 {
            let newValue = minusValue - 1
            courseCountTextField.text = String(newValue)
            courseCounter = newValue
        }
        
    }
    //MARK: - Views
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        view.layer.borderWidth = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var introLabel: UITextView = {
        let text = UITextView()
        text.text = "Please fill out the form below and submit it so the chef can review it."
        text.textAlignment = .center
        text.backgroundColor = .clear
        text.font = UIFont.boldSystemFont(ofSize: 18)
        text.textColor = UIColor.orangeColor()
        return text
    }()
    
    let peopleCountViewBG: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    var numberOfPeopleLabel: UILabel = {
        let label = UILabel()
        label.text = "How many people in party?"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    let peopleCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .white
        return stackView
    }()
    
    var peopleCountTextField: UITextField = {
        let text = UITextField()
        text.text = "1"
        text.textAlignment = .center
        text.isUserInteractionEnabled = false
        return text
    }()
    
    var peopleCountPlusButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "addButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleAddPeopleCount), for: .touchUpInside)
        return button
    }()
    
    var peopleCountMinusButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "minusButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleMinusPeopleCount), for: .touchUpInside)
        return button
    }()
    
    let courseCountViewBG: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    var numberOfCourseLabel: UILabel = {
        let label = UILabel()
        label.text = "How many courses?"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    let courseCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .white
        return stackView
    }()
    
    var courseCountTextField: UITextField = {
        let text = UITextField()
        text.text = "1"
        text.textAlignment = .center
        text.isUserInteractionEnabled = false
        return text
    }()
    
    var courseCountPlusButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "addButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleAddCourseCount), for: .touchUpInside)
        return button
    }()
    
    var courseCountMinusButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "minusButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleMinusCourseCount), for: .touchUpInside)
        return button
    }()
    
    let cuisineView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let cuisineTextField: UITextField = {
        let text = UITextField()
        text.font = UIFont.systemFont(ofSize: 17)
        text.placeholder = "Enter cuisine preference here..."
        text.textColor = UIColor.orangeColor()
        return text
    }()
    
    let locationViewBG: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let locationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add location", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handleAddLocation), for: .touchUpInside)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    let locationIndicatorIconView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "indicator")
        return image
    }()
    
    let datePickerViewBG: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.backgroundColor = .white
        datePicker.tintColor = UIColor.orangeColor()
        datePicker.overrideUserInterfaceStyle = .light
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        return datePicker
    }()
    
    var selectedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Please choose a date"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let timeLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        stackView.layer.shadowRadius = 4
        stackView.layer.shadowOpacity = 0.1
        stackView.layer.shadowColor = UIColor.lightGray.cgColor
        return stackView
    }()
    
    var startLabel: UILabel = {
        let label = UILabel()
        label.text = "Start Time"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    var endLabel: UILabel = {
        let label = UILabel()
        label.text = "End Time"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .white
        return stackView
    }()
    
    let timePickerViewBG: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var startTimeTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Select start time"
        textField.backgroundColor = .white
        textField.textColor = UIColor.orangeColor()
        textField.textAlignment = .center
        return textField
    }()
    
    let startTimePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(handleStartSelection), for: .valueChanged)
        return datePicker
    }()
    
    var endTimeTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Select end time"
        textField.backgroundColor = .white
        textField.textColor = UIColor.orangeColor()
        textField.textAlignment = .center
        return textField
    }()
    
    let endTimePickerView: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(handleEndSelection), for: .valueChanged)
        return datePicker
    }()
    
    let detailView: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let detailTextField: UITextView = {
        let text = UITextView()
        text.placeholder = "Enter any additional information ..."
        text.backgroundColor = .white
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
        return text
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit Request", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
}
