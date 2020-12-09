//
//  NewEventVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class NewEventVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var hasImage: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
//        captionView.delegate = self
//        postView.delegate = self
        setupView()
        setupNavItem()
        setupPickerViews()
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
    
    func setupPickerViews() {
        datePickerView()
        startTimePickerView()
        endTimePickerView()
    }
    
    @objc func validForm() {
        let isFormValid = captionView.text?.count ?? 0 > 0 && dateView.text?.count ?? 0 > 0 && locationTextField.text?.count ?? 0 > 0

        if isFormValid {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupNavItem() {
        navigationItem.title = "Add New Event"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(handleSubmit))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButton))
    }
    
    @objc func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    let captionView: UITextField = {
        let textView = UITextField()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.textColor = UIColor.darkGray
        textView.layer.cornerRadius = 5
        textView.attributedPlaceholder =
        NSAttributedString(string: "* Caption", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textView.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return textView
    }()

    var postView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.placeholder = "* Event Details..."
        textView.layer.cornerRadius = 5
        textView.textColor = UIColor.darkGray
//        textView.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return textView
    }()
    
    var locationTextField: UITextField = {
        let textView = UITextField()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textView.attributedPlaceholder =
        NSAttributedString(string: "* Event Address or Location", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textView.layer.cornerRadius = 5
        textView.textColor = UIColor.darkGray
        textView.addTarget(self, action: #selector(validForm), for: .editingChanged)
        return textView
    }()
    
    let locationImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "location")
        return image
    }()

    func textViewDidChange(_ textView: UITextView) {
        if (postView.text?.isEmpty)! {
            postView.placeholder = "Event Details..."
        } else {
            postView.placeholder = ""
        }

        if (postView.text?.isEmpty)! {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "NoUploads")
        return image
    }()
    
    let addPhotoButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 2
        button.backgroundColor = UIColor.orangeColor()
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
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
    
    fileprivate func setupView() {
        view.addSubview(self.scrollView)
        self.scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        self.scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(dateImageView)
        dateImageView.anchor(top: scrollView.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        scrollView.addSubview(dateView)
        dateView.anchor(top: dateImageView.topAnchor, left: dateImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 30)
        
        scrollView.addSubview(dateField)
        dateField.anchor(top: dateView.topAnchor, left: dateView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 110, height: 30)
        
        
        scrollView.addSubview(timeImageView)
        timeImageView.anchor(top: dateImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        scrollView.addSubview(startView)
        startView.anchor(top: timeImageView.topAnchor, left: timeImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 130, height: 30)
        
        scrollView.addSubview(endView)
        endView.anchor(top: timeImageView.topAnchor, left: startView.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 130, height: 30)
        
        scrollView.addSubview(captionView)
        captionView.anchor(top: endView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 35)
        
        scrollView.addSubview(postView)
        postView.anchor(top: captionView.bottomAnchor, left: captionView.leftAnchor, bottom: nil, right: captionView.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 250)
        
        scrollView.addSubview(locationImageView)
        locationImageView.anchor(top: postView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 15, paddingBottom: 10, paddingRight: 5, width: 30, height: 30)
        
        scrollView.addSubview(locationTextField)
        locationTextField.anchor(top: postView.bottomAnchor, left: locationImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 10, paddingRight: 15, width: 0, height: 35)
        
        scrollView.addSubview(requiredLabel)
        requiredLabel.anchor(top: locationTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        scrollView.addSubview(addPhotoButton)
        addPhotoButton.anchor(top: requiredLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 0)
        
        scrollView.addSubview(photoImageView)
        photoImageView.anchor(top: addPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: view.frame.width - 100, height: view.frame.width - 100)

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
    
    //MARK: ImageUpload
    
    @objc func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            photoImageView.image = editedImage
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            photoImageView.image = originalImage
        }
        
        hasImage = true
        
        dismiss(animated: true, completion: nil)
    }
    
//    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    
    @objc func handleSubmit() {
//        NotificationCenter.default.post(name: NewEventVC.updateNotificationName, object: nil)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let postRef = Database.database().reference().child(Constants.Event)
        let key = postRef.childByAutoId().key
        let timeStamp = Date().timeIntervalSince1970
        guard let image = photoImageView.image else { return }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(Constants.EventImages).child("\(filename).jpg")
        let date = self.dateField.text ?? ""
        let start = self.startView.text ?? ""
        let end = self.endView.text ?? ""
        let caption = self.captionView.text ?? ""
        let postText = self.postView.text ?? ""

        
        if hasImage == true {
            print("true")
            if let uploadData = image.jpegData(compressionQuality: 0.5) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print("print error")
                    }
                    storageRef.downloadURL(completion: { (downloadURL, err) in
                        if let err = err {
                            print("Failed to retrieve downloadURL:", err)
                            return
                        }
                        guard let imageUrl = downloadURL?.absoluteString else { return }
                        let values = [Constants.EventDate: date, Constants.StartTime: start, Constants.EndTime: end, Constants.Caption: caption, Constants.PostText: postText,  Constants.CreationDate: timeStamp, Constants.Uid: uid, Constants.Id: key!, Constants.BookmarkCount: 0, Constants.EventImageUrl: imageUrl, Constants.Address: self.locationTextField.text ?? ""] as! [String : Any]
                        
                        postRef.child(key!).updateChildValues(values) { (err, ref) in
                            
                            if let err = err {
                                print("Failed to insert comment:", err)
                                return
                            }
                            
                            print("Successfully inserted comment.")
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.updateScheduleWithEvent(eventKey: key!)
                    })
                    
                })
            }
        } else {
            let values = [Constants.EventDate: date, Constants.StartTime: start, Constants.EndTime: end, Constants.Caption: caption, Constants.PostText: postText,  Constants.CreationDate: timeStamp, Constants.Uid: uid, Constants.Id: key!, Constants.BookmarkCount: 0, Constants.Address: self.locationTextField.text ?? ""] as! [String : Any]
            
            postRef.child(key!).updateChildValues(values) { (err, ref) in
                
                if let err = err {
                    print("Failed to insert comment:", err)
                    return
                }
                
                print("Successfully inserted comment.")
                self.dismiss(animated: true, completion: nil)
            }
            self.updateScheduleWithEvent(eventKey: key!)

        }
    }
    
    func updateScheduleWithEvent(eventKey: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let postRef = Database.database().reference().child(Constants.Calendar).child(Constants.Schedule)
        let key = postRef.childByAutoId().key
        let date = self.dateField.text ?? ""
        let start = self.startView.text ?? ""
        let end = self.endView.text ?? ""
        let caption = self.captionView.text ?? ""
        let postText = self.postView.text ?? ""
        let values = [Constants.ScheduleDate: date, Constants.StartTime: start, Constants.EndTime: end, Constants.Title: caption, Constants.Note: postText, Constants.Uid: uid, Constants.Id: key!, Constants.Event: eventKey, Constants.Address: self.locationTextField.text ?? ""] as [String : Any]
        postRef.child(key!).updateChildValues(values) { (err, ref) in
            
            if let err = err {
                print("Failed to insert comment:", err)
                return
            }
            
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
