//
//  EditScheduleVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import JTAppleCalendar

class EditScheduleVC: UIViewController, UITextViewDelegate {
    
    var userId: String?
    var uid = Auth.auth().currentUser?.uid
    var user: User!
    var schedule: Schedule? {
        didSet {
            guard let schedule = schedule else {return}
            titleField.text = schedule.title
            notesField.text = schedule.note
            dateField.text = schedule.scheduleDate
            startTimeField.text = schedule.startTime
            endTimeField.text = schedule.endTime
            getDateFromDatabase()
            
            let uid = schedule.BookmarkedUser
            if schedule.BookmarkedUser == "" {
                
            } else {
//                Database.fetchUserWithUID(uid: uid!) { (user) in
//                    let profileImageUrl = user.profileImageUrl
//                    self.userProfileImageView.loadImage(urlString: profileImageUrl)
//                    let attributedText = NSMutableAttributedString(string: "Saved with ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black])
//                    attributedText.append(NSAttributedString(string: user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))
//                    
//                    self.usernameLabel.attributedText = attributedText
//                }
            }
            

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        notesField.delegate = self
        titleField.delegate = self
        setupView()
        setupPickerViews()
        setupNavTitleAndBarButtonItems()
//        setupKeyboard()
    }
    
    func setupKeyboard() {
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        self.notesField.inputAccessoryView = toolbar
        self.titleField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func getDateFromDatabase() {
        let dateString = schedule?.scheduleDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        let getDate = dateFormatter.date(from: dateString!)
        if dateString == "" {
            let date = Date()
            self.datePicker.setDate(date, animated: true)
        } else {
            self.datePicker.setDate(getDate!, animated: false)
        }
        
        let startString = schedule?.startTime
        let startTimeFormatter = DateFormatter()
        startTimeFormatter.dateFormat = "h:mma"
        let startTime = startTimeFormatter.date(from: startString!)
        if startString == "" {
            let date = Date()
            self.startTimePicker.setDate(date, animated: true)
        } else {
            self.startTimePicker.setDate(startTime!, animated: false)
        }
        
        let endString = schedule?.endTime
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
        navigationItem.title = "Edit Schedule"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleUpdate))
    }
    
    let titleField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textColor = UIColor.black
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    var notesField: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textColor = UIColor.black
        textView.layer.cornerRadius = 5
        return textView
    }()
    
    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let characterLimit = 40
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if range.length + range.location > titleField.text.count {
            return false
        }
        let newLength = titleField.text.count + text.count - range.length
        return newLength <= 40
    }
    
    fileprivate func setupView() {
        
        view.addSubview(titleField)
        titleField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 35)
        
        view.addSubview(notesField)
    
        notesField.anchor(top: titleField.bottomAnchor, left: titleField.leftAnchor, bottom: nil, right: titleField.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 300)
        
        
        view.addSubview(countLabel)
        countLabel.anchor(top: notesField.bottomAnchor, left: nil, bottom: nil, right: notesField.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 25)
        
        let fieldStackView = UIStackView(arrangedSubviews: [dateView, startView, endView])
        fieldStackView.axis = .horizontal
        fieldStackView.distribution = .fillEqually
        fieldStackView.spacing = 5
        view.addSubview(fieldStackView)
        fieldStackView.anchor(top: countLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        
        let viewStackView = UIStackView(arrangedSubviews: [dateField, startTimeField, endTimeField])
        viewStackView.axis = .horizontal
        viewStackView.distribution = .fillEqually
        viewStackView.spacing = 5
        view.addSubview(viewStackView)
        viewStackView.anchor(top: fieldStackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 35)
        
        view.addSubview(userProfileImageView)
        userProfileImageView.anchor(top: viewStackView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        userProfileImageView.layer.cornerRadius = 50 / 2
        userProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: userProfileImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
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
        let currentUser = Auth.auth().currentUser?.uid
        let ref = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule).queryOrdered(byChild: Constants.Uid).queryEqual(toValue: currentUser)
        let userKeyRef = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule)
        
        let values = [Constants.ScheduleDate: dateField.text ?? "", Constants.StartTime: startTimeField.text ?? "", Constants.EndTime: endTimeField.text ?? "", Constants.Title: titleField.text ?? "", Constants.Note: notesField.text ?? "", Constants.Uid: uid!] as [String : Any]
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                for child in result {
                    let userKey = child.key
                    let currentKey = self.schedule?.id
                    if(userKey == currentKey){
                        userKeyRef.child(userKey).updateChildValues(values)
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
            NotificationCenter.default.post(name: EditEventDetailVC.updateNotificationName, object: nil)
        }
    }
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

}

