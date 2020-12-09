//
//  EditEventDetailVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class EditEventDetailVC: UIViewController {
    var userId: String?
    var uid = Auth.auth().currentUser?.uid
    var user: User!
    var event: Event? {
        didSet {
            guard let event = event else {return}
            captionView.text = event.caption
            postView.text = event.postText
            dateField.text = event.eventDate
            startTimeField.text = event.startTime
            endTimeField.text = event.endTime
            getDateFromDatabase()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
        setupPickerViews()
        setupNavTitleAndBarButtonItems()
        scrollView.keyboardDismissMode = .onDrag
//        setupKeyboard()
    }
    
    func setupKeyboard() {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.captionView.inputAccessoryView = toolbar
        self.postView.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func getDateFromDatabase() {
        let dateString = event?.eventDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let getDate = dateFormatter.date(from: dateString!)
        if dateString == "" {
            let date = Date()
            self.datePicker.setDate(date, animated: true)
        } else {
            self.datePicker.setDate(getDate!, animated: false)
        }
        
        let startString = event?.startTime
        let startTimeFormatter = DateFormatter()
        startTimeFormatter.dateFormat = "h:mma"
        let startTime = startTimeFormatter.date(from: startString!)
        if startString == "" {
            let date = Date()
            self.startTimePicker.setDate(date, animated: true)
        } else {
            self.startTimePicker.setDate(startTime!, animated: false)
        }
        
        let endString = event?.endTime
        let endTimeFormatter = DateFormatter()
        endTimeFormatter.dateFormat = "h:mma"
        let endTime = endTimeFormatter.date(from: endString!)
        
        if endString == "" {
            let date = Date()
            self.endTimePicker.setDate(date, animated: true)
        } else {
            self.endTimePicker.setDate(endTime!, animated: false)
        }
    }
    
    func setupPickerViews() {
        datePickerView()
        startTimePickerView()
        endTimePickerView()
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Edit Event"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleUpdate))
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor()
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate func setupView() {
        
        view.addSubview(self.scrollView)
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        
        self.scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(captionView)
        captionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 120, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 35)
        
        scrollView.addSubview(postView)
        postView.anchor(top: captionView.bottomAnchor, left: captionView.leftAnchor, bottom: nil, right: captionView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 250)
        
        scrollView.addSubview(countLabel)
        countLabel.anchor(top: postView.bottomAnchor, left: nil, bottom: nil, right: postView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let fieldStackView = UIStackView(arrangedSubviews: [dateView, startView, endView])
        fieldStackView.axis = .horizontal
        fieldStackView.distribution = .fillEqually
        fieldStackView.spacing = 5
        scrollView.addSubview(fieldStackView)
        fieldStackView.anchor(top: countLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        let viewStackView = UIStackView(arrangedSubviews: [dateField, startTimeField, endTimeField])
        viewStackView.axis = .horizontal
        viewStackView.distribution = .fillEqually
        viewStackView.spacing = 5
        scrollView.addSubview(viewStackView)
        viewStackView.anchor(top: fieldStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35)
    }
    
    @objc func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    let captionView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    var postView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let characterLimit = 40
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > captionView.text.count {
            return false
        }
        let newLength = captionView.text.count + text.count - range.length
        return newLength <= 40
    }

//    func textViewDidChange(_ textView: UITextView) {
//        countLabel.text = "\(650 - postView.text.count) characters left"
//    }
//
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//        let currentText = postView.text as NSString
//        let updatedText = currentText.replacingCharacters(in: range, with: text)
//
//        return updatedText.count <= 650
//    }
    
    //MARK: PICKER SETUP
    func datePickerView() {
        dateField.inputView = datePicker
        dateView.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        
        toolbar.tintColor = UIColor.black
        
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain, target: self, action: #selector(todayPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dateDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.text = "Select a Date"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([todayButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        
        dateField.inputAccessoryView = toolbar
        dateView.inputAccessoryView = toolbar
    }
    
    func startTimePickerView() {
        startTimeField.inputView = startTimePicker
        startView.inputView = startTimePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        
        toolbar.tintColor = UIColor.black
        
        let timeButton = UIBarButtonItem(title: "Current", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.text = "Select Start Time"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([timeButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        
        startTimeField.inputAccessoryView = toolbar
        startView.inputAccessoryView = toolbar
    }
    
    func endTimePickerView() {
        endTimeField.inputView = endTimePicker
        endView.inputView = endTimePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        
        toolbar.barStyle = UIBarStyle.default
        
        toolbar.tintColor = UIColor.black
        
        let timeButton = UIBarButtonItem(title: "Current", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endPressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(endDonePressed(sender:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        label.text = "Select End Time"
        let labelButton = UIBarButtonItem(customView: label)
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        toolbar.setItems([timeButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        
        endTimeField.inputAccessoryView = toolbar
        endView.inputAccessoryView = toolbar
    }
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.time
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(startTimePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.time
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.setValue(false, forKey: "highlightsToday")
        picker.addTarget(self, action: #selector(endTimePickerValueChanged(_:)), for: UIControl.Event.valueChanged)
        return picker
    }()
    
    let dateField: UITextView = {
        let text = UITextView()
        let date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, yyyy"
        let todaysDate: String = dateFormatter.string(from: date)
        text.isEditable = false
        text.textAlignment = .center
        text.textColor = UIColor.black
        text.backgroundColor = UIColor.white
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    let startTimeField: UITextView = {
        let text = UITextView()
        let date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let todaysDate: String = dateFormatter.string(from: date)
        text.isEditable = false
        text.textAlignment = .center
        text.textColor = UIColor.black
        text.backgroundColor = UIColor.white
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    let endTimeField: UITextView = {
        let text = UITextView()
        let date = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let todaysDate: String = dateFormatter.string(from: date)
        text.isEditable = false
        text.textAlignment = .center
        text.textColor = UIColor.black
        text.backgroundColor = UIColor.white
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
        return text
    }()
    
    let dateView: UITextView = {
        let text = UITextView()
        text.text = "Selected Date"
        text.font = UIFont.boldSystemFont(ofSize: 14)
        text.textAlignment = .center
        text.textColor = UIColor.black
        text.backgroundColor = UIColor.white
        text.layer.cornerRadius = 5
        text.isEditable = false
        return text
    }()
    
    let startView: UITextView = {
        let text = UITextView()
        text.text = "Start Time"
        text.font = UIFont.boldSystemFont(ofSize: 14)
        text.textAlignment = .center
        text.textColor = UIColor.black
        text.backgroundColor = UIColor.white
        text.layer.cornerRadius = 5
        text.isEditable = false
        return text
    }()
    
    let endView: UITextView = {
        let text = UITextView()
        text.text = "End Time"
        text.font = UIFont.boldSystemFont(ofSize: 14)
        text.textAlignment = .center
        text.textColor = UIColor.black
        text.backgroundColor = UIColor.white
        text.layer.cornerRadius = 5
        text.isEditable = false
        return text
    }()
    
    @objc func dateDonePressed(sender: UIBarButtonItem) {
        dateField.resignFirstResponder()
        dateView.resignFirstResponder()
    }
    
    @objc func startDonePressed(sender: UIBarButtonItem) {
        startTimeField.resignFirstResponder()
        startView.resignFirstResponder()
    }
    
    @objc func endDonePressed(sender: UIBarButtonItem) {
        endTimeField.resignFirstResponder()
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
        
        startTimeField.text = formatter.string(from: NSDate() as Date)
        
        startTimeField.resignFirstResponder()
    }
    
    @objc func endPressed(sender: UIBarButtonItem) {
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.none
        
        formatter.timeStyle = DateFormatter.Style.short
        endTimeField.text = formatter.string(from: NSDate() as Date)
        
        endTimeField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let selectedDate: String = dateFormatter.string(from: sender.date)
        dateField.text = ("\(selectedDate)")
        
    }
    
    @objc func startTimePickerValueChanged(_ sender: UIDatePicker){
        
        endTimePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: startTimePicker.date)
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
        
        let selectedTime: String = dateFormatter.string(from: sender.date)
        startTimeField.text = ("\(selectedTime)")
        
    }
    
    @objc func endTimePickerValueChanged(_ sender: UIDatePicker){
        
        
        let dateFormatter: DateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h:mm a"
        
        let selectedTime: String = dateFormatter.string(from: sender.date)
        endTimeField.text = ("\(selectedTime)")
        
    }
    
    @objc func donePressed(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    @objc func handleUpdate() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child(Constants.Event)
        let timeStamp = self.datePicker.date.timeIntervalSince1970
        
        let values = [Constants.EventDate: dateField.text ?? "", Constants.StartTime: startTimeField.text ?? "", Constants.EndTime: endTimeField.text ?? "", Constants.Caption: captionView.text ?? "", Constants.PostText: postView.text ?? "", Constants.CreationDate: timeStamp, Constants.Uid: uid] as [String : Any]

        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let userKey = child.key
                    let currentKey = self.event?.id
                    if(userKey == currentKey){
                        self.updateSchedule(eventKey: userKey)
                        ref.child(userKey).updateChildValues(values)
                    }
                }
            }
            
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: EditEventDetailVC.updateNotificationName, object: nil)
        }

    }
    
    func updateSchedule(eventKey: String) {
        let scheduleValues = [Constants.ScheduleDate: self.dateField.text ?? "", Constants.StartTime: self.startTimeField.text ?? "", Constants.EndTime: self.endTimeField.text ?? "", Constants.Title: self.captionView.text ?? "", Constants.Note: self.postView.text ?? ""] as [String : Any]
        
        Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).child(key).observe(.value, with: { (snapshot) in
                    
                    guard let dictionary = value as? [String: Any] else { return }
                    let eventId  = dictionary[Constants.Event] as? String
                    
                    if eventId == eventKey {
                        Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).child(key).updateChildValues(scheduleValues)
                    }
                })
            })
        })
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
}


