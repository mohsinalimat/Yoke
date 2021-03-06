//
//  NewEventViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/22/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import FirebaseAuth

class NewEventViewController: UIViewController,  EventLocationDelegate {
    
    //MARK: - Properties
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    let eventImagePicker = UIImagePickerController()
    var uid = Auth.auth().currentUser?.uid ?? ""
    var eventExist: Bool = false
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    var rsvp: Bool = false
    var contact: Bool = false
    var selectedLocation: String = ""
    var selectedShortLocation: String = ""
    var event: Event? {
        didSet {
            fetchEvent()
        }
    }
    
    //MARK: - Lifecycle Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupViews()
        constrainViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupImagePicker()
        setupPickerViews()
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        view.backgroundColor = UIColor.LightGrayBg()
        view.addSubview(swipeIndicator)
        view.addSubview(saveButton)
        view.addSubview(deleteButton)
        view.addSubview(eventLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(eventImageShadowView)
        scrollView.addSubview(eventImageView)
        scrollView.addSubview(eventAddImageButton)
        scrollView.addSubview(captionViewBG)
        scrollView.addSubview(captionTextField)
        scrollView.addSubview(eventViewBG)
        scrollView.addSubview(eventDetailTextField)
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
        scrollView.addSubview(contactLabel)
        scrollView.addSubview(contactSwitch)
        scrollView.addSubview(contactInfoLabel)
        view.addSubview(myActivityIndicator)
    }
    
    func constrainViews() {
        swipeIndicator.anchor(top: safeArea.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 20)
        deleteButton.anchor(top: swipeIndicator.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 20, paddingBottom: 0, paddingRight: 0)
        eventLabel.anchor(top: swipeIndicator.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        eventLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 500)
        scrollView.anchor(top: eventLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: safeArea.bottomAnchor, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        eventImageShadowView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: 300)
        eventImageView.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: 300)
        eventAddImageButton.anchor(top: scrollView.topAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: view.frame.width / 2, height: 300)
        captionViewBG.anchor(top: eventImageView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 8, paddingRight: 10, height: 45)
        captionTextField.anchor(top: captionViewBG.topAnchor, left: captionViewBG.leftAnchor, bottom: captionViewBG.bottomAnchor, right: captionViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        eventViewBG.anchor(top: captionTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 8, height: 150)
        eventDetailTextField.anchor(top: eventViewBG.topAnchor, left: eventViewBG.leftAnchor, bottom: eventViewBG.bottomAnchor, right: eventViewBG.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
        locationViewBG.anchor(top: eventDetailTextField.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, height: 45)
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
        
        contactLabel.anchor(top: timeStackView.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        contactSwitch.anchor(top: contactLabel.topAnchor, left: nil, bottom: nil, right: safeArea.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10)
        contactInfoLabel.anchor(top: contactLabel.bottomAnchor, left: safeArea.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0)
        
        myActivityIndicator.center = view.center
    }
    
    func fetchEvent() {
        guard let event = event,
              let image = event.eventImageUrl else { return }
        eventImageView.loadImage(urlString: image)
        captionTextField.text = event.caption
        eventDetailTextField.text = event.detail
        locationButton.setTitle(event.location, for: .normal)
        selectedDateLabel.text = event.date
        startTimeTextField.text = event.startTime
        endTimeTextField.text = event.endTime
    
        if event.allowsContact == true {
            contactSwitch.isOn = true
        }
    }
    
    func setupImagePicker() {
        eventImagePicker.delegate = self
    }
    
    func setupPickerViews() {
        datePickerView.minimumDate = Date()
        startTimeTextField.inputView = startTimePickerView
        endTimeTextField.inputView = endTimePickerView
    }
    
    func saveSuccessful() {
        let alertVC = UIAlertController(title: "Success", message: "Your event has been added!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool Beans", style: .default) { (_) in
            self.handleDismiss()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func deleteSuccessful() {
        let alertVC = UIAlertController(title: "Success", message: "Your event has been deleted!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool Beans", style: .default) { (_) in
            self.handleDismiss()
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true)
    }
    
    func eventLocationController(_ eventLocationController: EventLocationViewController, didSelectLocation location: String, short: String) {
        selectedShortLocation = short
        selectedLocation = location
        locationButton.setTitle(location, for: .normal)
    }
    
    //MARK: - Selectors
    @objc func handleAddImage() {
        let alertVC = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.eventImagePicker.dismiss(animated: true)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(cameraAction)
        alertVC.addAction(photoLibraryAction)
        present(alertVC, animated: true)
    }
    
    
    @objc func handleSave() {
        guard let caption = captionTextField.text, !caption.isEmpty,
              let detail = eventDetailTextField.text, !detail.isEmpty,
              let date = selectedDateLabel.text,
              let start = startTimeTextField.text,
              let end = endTimeTextField.text else { return }
        let image = eventImageView.image
        if selectedLocation.isEmpty {
            guard let location = event?.location else { return }
            selectedLocation = location
        }
        myActivityIndicator.startAnimating()
        if eventExist == true {
            guard let  eventId = event?.id,
                  let uid = event?.uid else { return }
            EventController.shared.updateEventWith(uid: uid, eventId: eventId, image: image, caption: caption, detailText: detail, date: date, startTime: start, endTime: end, location: selectedLocation, shortLocation: selectedShortLocation, allowsRSVP: rsvp, allowsContact: contact) { (result) in
                switch result {
                case true:
                    self.myActivityIndicator.stopAnimating()
                    self.saveSuccessful()
                case false:
                    print("failed to save")
                }
            }
        } else {
            EventController.shared.createEventWith(uid: uid, image: image, caption: caption, detailText: detail, date: date, startTime: start, endTime: end, location: selectedLocation, shortLocation: selectedShortLocation, allowsRSVP: rsvp, allowsContact: contact) { (result) in
                switch result {
                case true:
                    self.myActivityIndicator.stopAnimating()
                    self.saveSuccessful()
                case false:
                    print("failed to save")
                }
            }
        }
    }
    
    @objc func handleDeleteEvent() {
        guard let eventId = event?.id,
              let imageId = event?.imageId else { return }
        self.myActivityIndicator.startAnimating()
        EventController.shared.deleteEventWith(eventId: eventId, imageId: imageId) { (result) in
            switch result {
            case true:
                self.myActivityIndicator.stopAnimating()
                self.deleteSuccessful()
            case false:
                print("error in delete menu")
            }
        }
    }
    
    @objc func handleAddLocation() {
        let chooseLocation = EventLocationViewController()
        chooseLocation.delegate = self
        present(chooseLocation, animated: true)
    }
    
    @objc func handleDateSelection() {
        let datePicker = datePickerView
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        selectedDateLabel.text = dateFormatter.string(from: datePicker.date)
        selectedDateLabel.font = UIFont.systemFont(ofSize: 17)
    }
    
    @objc func handleStartSelection() {
        let startPicker = startTimePickerView
        let startTimeFormatter = DateFormatter()
        startTimeFormatter.timeStyle = .short
        startTimeTextField.text = startTimeFormatter.string(from: startPicker.date)
    }
    
    @objc func handleEndSelection() {
        let endPicker = endTimePickerView
        let endTimeFormatter = DateFormatter()
        endTimeFormatter.timeStyle = .short
        endTimeTextField.text = endTimeFormatter.string(from: endPicker.date)
    }
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rsvpSwitch(rsvpSwitchChanged: UISwitch) {
        if rsvpSwitch.isOn {
            rsvp = true
        } else {
            rsvp = false
        }
    }
    
    @objc func contactSwitch(contactSwitchChanged: UISwitch) {
        if contactSwitch.isOn {
            contact = true
        } else {
            contact = false
        }
    }
    
    //MARK: - Views
    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.layer.cornerRadius = 10
        return view
    }()
    
    var eventLabel: UILabel = {
        let label = UILabel()
        label.text = "Create Event"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .gray
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleDeleteEvent), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.LightGrayBg()
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.LightGrayBg()?.cgColor
        view.layer.borderWidth = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let eventImageShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor = UIColor.lightGray.cgColor
        return view
    }()
    
    let eventImageView: CustomImageView = {
        let image = CustomImageView()
//        image.image = UIImage(named: "gradientBackgroundHalf")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        return image
    }()
    
    let eventAddImageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add an image", for: .normal)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleAddImage), for: .touchUpInside)
        return button
    }()
    
    let captionViewBG: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let captionTextField: UITextField = {
        let text = UITextField()
        text.textColor = .darkGray
        text.attributedPlaceholder = NSAttributedString(string: " Enter Caption", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return text
    }()
    
    let eventViewBG: ShadowView = {
        let view = ShadowView()
        view.backgroundColor = .white
        return view
    }()
    
    let eventDetailTextField: UITextView = {
        let text = UITextView()
        text.placeholder = "Enter event details"
        text.textColor = .darkGray
        text.isEditable = true
        text.isScrollEnabled = true
        text.textContainer.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: 17)
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
    
    var rsvpLabel: UILabel = {
        let label = UILabel()
        label.text = "Show RSVP?"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    var rsvpInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Allows users RSVP to your event"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    var rsvpSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.onTintColor = UIColor.orangeColor()
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(rsvpSwitch(rsvpSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
    
    var contactLabel: UILabel = {
        let label = UILabel()
        label.text = "Show Contact?"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    var contactInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Allows users contact your about your event"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    var contactSwitch: UISwitch = {
        let switchBool = UISwitch()
        switchBool.onTintColor = UIColor.orangeColor()
        switchBool.setOn(false, animated: true)
        switchBool.addTarget(self, action: #selector(contactSwitch(contactSwitchChanged:)), for: UIControl.Event.valueChanged)
        return switchBool
    }()
}

//MARK: - Image Picker
extension NewEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            eventImagePicker.sourceType = .camera
            eventImagePicker.allowsEditing = false
            self.present(eventImagePicker, animated: true)
        } else {
            let alertVC = UIAlertController(title: "No Camera Acccess", message: "Please allow access to the camera to use this feature", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            eventImagePicker.sourceType = .photoLibrary
            eventImagePicker.allowsEditing = true
            self.present(eventImagePicker, animated: true)
        } else {
            let alertVC = UIAlertController(title: "No Photo Acccess", message: "Please allow access to Photos to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            self.eventImageView.image = pickedImage
        }
        picker.dismiss(animated: true)
    }
}

extension UIDatePicker {
    
    var textColor: UIColor? {
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
    }
}
