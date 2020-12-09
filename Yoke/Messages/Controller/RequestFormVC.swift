//
//  RequestFormVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 6/8/20.
//  Copyright © 2020 LAURA JELENICH. All rights reserved.
//

import UIKit
import Kingfisher

class RequestFormVC: UIViewController {
    
    var user: User? {
        didSet{
            guard let user = user else {return}
            print(user.username)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Chef Request Form"
        setupNavTitleAndBarButtonItems()
        setupViews()
        setupPickerViews()
        validForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func validForm() {
        let isFormValid = countField.text?.count ?? 0 > 0 && budgetField.text?.count ?? 0 > 0 && dateView.text?.count ?? 0 > 0
        
        if isFormValid {
            submitButton.isEnabled = true
            submitButton.backgroundColor = UIColor.orangeColor()
        } else {
            submitButton.isEnabled = false
            submitButton.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(0.8)
        }
    }

    func setupPickerViews() {
           datePickerView()
           startTimePickerView()
           endTimePickerView()
       }
    
    func setupNavTitleAndBarButtonItems() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.black
    }

    let peopleImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "no_post_icon_color")
        return image
    }()
    
    let peopleView: UITextView = {
        let text = UITextView()
        text.text = " * How many people?"
        text.backgroundColor = UIColor.white
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.isEditable = false
        return text
    }()
    
    let countField: UITextField = {
        let text = UITextField()
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.setLeftPaddingPoints(5)
        text.keyboardType = .numberPad
        text.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return text
    }()
    
    let budgetImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "payment_unselected")
        return image
    }()
    
    let budgetView: UITextView = {
        let text = UITextView()
        text.text = " * Budget?"
        text.backgroundColor = UIColor.white
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        return text
    }()
    
    let budgetField: UITextField = {
        let text = UITextField()
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.setLeftPaddingPoints(5)
        text.keyboardType = .numberPad
        text.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return text
    }()
    
    let detailField: UITextView = {
        let text = UITextView()
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.placeholder = "What are your needs?"
        return text
    }()
    
    var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Send Request", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(0.8)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(sendRequest), for: .touchUpInside)
        return button
    }()
    
    let requiredLabel: UILabel = {
        let label = UILabel()
        label.text = "* required"
        label.textColor = UIColor.orangeColor()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    func setupViews() {
        view.addSubview(dateImageView)
        dateImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        view.addSubview(dateView)
        dateView.anchor(top: dateImageView.topAnchor, left: dateImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 30)
        
        view.addSubview(dateField)
        dateField.anchor(top: dateView.topAnchor, left: dateView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 110, height: 30)
        
        
        view.addSubview(timeImageView)
        timeImageView.anchor(top: dateImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        view.addSubview(startView)
        startView.anchor(top: timeImageView.topAnchor, left: timeImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 130, height: 30)
        
        view.addSubview(endView)
        endView.anchor(top: timeImageView.topAnchor, left: startView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 130, height: 30)
        
        view.addSubview(peopleImageView)
        peopleImageView.anchor(top: timeImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 13, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        
        view.addSubview(peopleView)
        peopleView.anchor(top: peopleImageView.topAnchor, left: peopleImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 160, height: 30)
        
        view.addSubview(countField)
        countField.anchor(top: peopleImageView.topAnchor, left: peopleView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 30)
        
        view.addSubview(budgetImageView)
        budgetImageView.anchor(top: peopleImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        view.addSubview(budgetView)
        budgetView.anchor(top: budgetImageView.topAnchor, left: budgetImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 90, height: 30)
        
        view.addSubview(budgetField)
        budgetField.anchor(top: budgetImageView.topAnchor, left: budgetView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 50, height: 30)
        
        view.addSubview(detailField)
        detailField.anchor(top: budgetImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 300)
        
        view.addSubview(submitButton)
        submitButton.anchor(top: detailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)
        
        view.addSubview(requiredLabel)
        requiredLabel.anchor(top: submitButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    }
    
    //MARK: PICKER SETUP
    func datePickerView() {
        dateView.inputView = datePicker
        dateField.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.orangeColor()
        
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: #selector(todayPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dateDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Select a Date"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([todayButton, flexButton, labelButton, flexButton, doneButton], animated: true)

        dateView.inputAccessoryView = toolbar
        dateField.inputAccessoryView = toolbar
    }
    
    func startTimePickerView() {
        startView.inputView = startTimePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.orangeColor()
        
        let timeButton = UIBarButtonItem(title: "Current", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Select Start Time"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([timeButton, flexButton, labelButton, flexButton, doneButton], animated: true)

        startView.inputAccessoryView = toolbar
    }
    
    func endTimePickerView() {
        endView.inputView = endTimePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.orangeColor()
        
        let timeButton = UIBarButtonItem(title: "Current", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.text = "Select End Time"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([timeButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        
        endView.inputAccessoryView = toolbar
    }
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.time
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(startTimePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.time
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.darkGray, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(endTimePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let dateImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "calendar_unselected")
        return image
    }()
    
    let timeImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "clock")
        return image
    }()
    
    let dateView: UITextView = {
        let text = UITextView()
        text.text = " * Date"
        text.font = UIFont.systemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.backgroundColor = UIColor.white
        text.isEditable = false
        return text
    }()
    let dateField: UITextField = {
        let text = UITextField()
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.lightGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 2
        text.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return text
    }()
    
    let startView: UITextView = {
        let text = UITextView()
        text.text = " From"
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.lightGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 2
        text.isEditable = false
        return text
    }()
    
    let endView: UITextView = {
        let text = UITextView()
        text.text = " To"
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.lightGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 2
        text.isEditable = false
        return text
    }()
    
    @objc func dateDonePressed(sender: UIBarButtonItem) {
        dateView.resignFirstResponder()
        dateField.resignFirstResponder()
    }
    
    @objc func startDonePressed(sender: UIBarButtonItem) {
        startView.resignFirstResponder()
    }
    
    @objc func endDonePressed(sender: UIBarButtonItem) {
        endView.resignFirstResponder()
    }
    
    
    @objc func todayPressed(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        formatter.timeStyle = DateFormatter.Style.none
        
        dateField.text = formatter.string(from: NSDate() as Date)
        
        dateField.resignFirstResponder()
    }
    
    @objc func startPressed(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.none
        
        formatter.timeStyle = DateFormatter.Style.short
        
        startView.text = formatter.string(from: NSDate() as Date)
        
        startView.resignFirstResponder()
    }
    
    @objc func endPressed(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.none
        
        formatter.timeStyle = DateFormatter.Style.short
        endView.text = formatter.string(from: NSDate() as Date)
        
        endView.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let selectedDate: String = dateFormatter.string(from: sender.date)
        dateField.text = (" \(selectedDate)")
        dateField.textColor = UIColor.darkGray
        
    }
    
    @objc func startTimePickerValueChanged(_ sender: UIDatePicker){
        
        endTimePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: startTimePicker.date)
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
        
        let selectedTime: String = dateFormatter.string(from: sender.date)
        startView.text = (" From: \(selectedTime)")
        startView.textColor = UIColor.darkGray
        
    }
    
    @objc func endTimePickerValueChanged(_ sender: UIDatePicker){
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
        
        let selectedTime: String = dateFormatter.string(from: sender.date)
        endView.text = (" To: \(selectedTime)")
        endView.textColor = UIColor.darkGray
        
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    //MARK: Send
    @objc func sendRequest() {
           print("sent")
       }
}
