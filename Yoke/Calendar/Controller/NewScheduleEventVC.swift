//
//  NewScheduleEventVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class NewScheduleEventVC: UIViewController {
    
    var userId: String?
    var uid = Auth.auth().currentUser?.uid

    var user: User? {
        didSet {
            if user?.uid == Auth.auth().currentUser?.uid {
                userProfileImageView.isHidden = true
                usernameField.text = ""
            } else {
//                guard let profileImageUrl = user?.profileImageUrl else { return }
//                userProfileImageView.loadImage(urlString: profileImageUrl)
//                let attributedText = NSMutableAttributedString(string: user!.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//                attributedText.append(NSAttributedString(string: " " + "This is for your reference only. The user will not have access to your notes.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
//                
//                usernameField.attributedText = attributedText
            }
            
        }
    }
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.user = user
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        setupPickerViews()
        setupNavTitleAndBarButtonItems()
        fetchUser()

    }
    
//    @objc func validForm() {
//        let isFormValid = countField.text?.count ?? 0 > 0 && budgetField.text?.count ?? 0 > 0 && dateView.text?.count ?? 0 > 0
//
//        if isFormValid {
//            submitButton.isEnabled = true
//            submitButton.backgroundColor = UIColor.mainColor()
//        } else {
//            submitButton.isEnabled = false
//            submitButton.backgroundColor = UIColor.mainColor().withAlphaComponent(0.8)
//        }
//    }

    func setupPickerViews() {
           datePickerView()
           startTimePickerView()
           endTimePickerView()
       }
    
    func setupNavTitleAndBarButtonItems() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.black
        self.navigationController?.title = "Notes"
    }

    let userProfileImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let usernameField: UILabel = {
        let text = UILabel()
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.numberOfLines = 2
        return text
    }()
    
    let titleField: UITextView = {
        let text = UITextView()
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.placeholder = "Title..."
        return text
    }()
    
    let notesField: UITextView = {
        let text = UITextView()
        text.font = UIFont.boldSystemFont(ofSize: 15)
        text.textAlignment = .left
        text.textColor = UIColor.darkGray
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.placeholder = "Notes..."
        return text
    }()
    
    var submitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = UIColor.orangeColor()?.withAlphaComponent(0.8)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
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

        view.addSubview(titleField)
        titleField.anchor(top: timeImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 130, height: 30)

        view.addSubview(notesField)
        notesField.anchor(top: titleField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 100)

        view.addSubview(userProfileImageView)
        userProfileImageView.anchor(top: notesField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 60, height: 60)
        userProfileImageView.layer.cornerRadius = 30

        view.addSubview(usernameField)
        usernameField.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 5, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)

//        view.addSubview(submitButton)
//        submitButton.anchor(top: notesField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)


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
        text.font = UIFont.boldSystemFont(ofSize: 15)
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
//        text.addTarget(self, action: #selector(validForm), for: .editingChanged)
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
    
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    @objc func handleSave() {
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        let postRef = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule)
//        let key = postRef.childByAutoId().key
//        let userId = user?.uid
//
//        if dateField.text == "" || titleField.text == ""{
//            handleAddDateAction()
//        } else {
//            if userId == Auth.auth().currentUser?.uid {
//                let values = [Constants.ScheduleDate: dateField.text ?? "", Constants.StartTime: startTimeField.text ?? "", Constants.EndTime: endTimeField.text ?? "", Constants.Title: titleField.text ?? "", Constants.Note: notesField.text ?? "", Constants.Uid: uid, Constants.Id: key ?? ""] as [String : Any]
//                postRef.child(key!).updateChildValues(values) { (err, ref) in
//
//                    if let err = err {
//                        print("Failed to insert comment:", err)
//                        return
//                    }
//
//                }
//            } else {
//                //Saved if there is a user
//                let values = [Constants.ScheduleDate: dateField.text ?? "", Constants.StartTime: startTimeField.text ?? "", Constants.EndTime: endTimeField.text ?? "", Constants.Title: titleField.text ?? "", Constants.Note: notesField.text ?? "", Constants.Uid: uid, Constants.Id: key ?? "", Constants.BookmarkedUser: userId ?? ""] as [String : Any]
//                postRef.child(key!).updateChildValues(values) { (err, ref) in
//
//                    if let err = err {
//                        print("Failed to insert comment:", err)
//                        return
//                    }
//
//                }
//            }
//            let calendarVC = CalendarVC()
//            self.navigationController?.pushViewController(calendarVC, animated: true)
//        }
        
    }

    func handleAddDateAction() {
        let alertController = UIAlertController(title: "There was a problem", message: "You must pick a date from the calendar and add a title before saving", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Got it!", style: .cancel) { action in
        }
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {
        }
    }

}
