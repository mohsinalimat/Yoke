//
//  EditPhotoVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class EditPhotoVC: UIViewController, UITextViewDelegate {

//    var userId: String?
//    var updatedText: String?
//    var uid = Auth.auth().currentUser?.uid
//    var user: User!
//    var gallery: Gallery? {
//        didSet {
//            guard let gallery = gallery else {return}
//            captionView.text = gallery.caption
//            locationTextField.text = gallery.location
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.white
//        
//        view.addSubview(captionView)
//        captionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 250)
//        
//        view.addSubview(locationTextField)
//        locationTextField.anchor(top: captionView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 35)
////        captionView.delegate = self
////
////        view.addSubview(captionView)
////        captionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 75)
////
////        view.addSubview(countLabel)
////        countLabel.anchor(top: captionView.bottomAnchor, left: nil, bottom: nil, right: captionView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
////
////        view.addSubview(locationTextField)
////        locationTextField.anchor(top: countLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 35)
////
////        locationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: locationTextField.frame.height))
////        locationTextField.leftViewMode = .always
////
////        locationTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: locationTextField.frame.height))
////        locationTextField.rightViewMode = .always
//        
//        view.addSubview(updateLabel)
//        updateLabel.anchor(top: locationTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//        updateLabel.isHidden = true
//        setupNavTitleAndBarButtonItems()
//    }
//    
//    func setupNavTitleAndBarButtonItems() {
//        
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.view.backgroundColor = UIColor.black
//        
//        navigationItem.title = "Edit Photo"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleUpdate))
//    }
//    
//    let countLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .lightGray
//        label.font = UIFont.systemFont(ofSize: 12)
//        return label
//    }()
//    
//    func textViewDidChange(_ textView: UITextView) {
//        countLabel.text = "\(150 - captionView.text.count) characters left"
//    }
//    
//    let CharacterLimit = 150
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let currentText = captionView.text as NSString
//        let updatedText = currentText.replacingCharacters(in: range, with: text)
//        
//        return updatedText.count <= CharacterLimit
//    }
//
//    @objc func handleUpdate() {
//        guard let uid = gallery?.user.uid else { return }
//        let ref = Database.database().reference().child(Constants.Gallery).child(uid)
//        let values = [Constants.Caption: captionView.text ?? "", Constants.Location: locationTextField.text ?? ""] as [String : Any]
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//            if let result = snapshot.children.allObjects as? [DataSnapshot] {
//                for child in result {
//                    let userKey = child.key
//                    let currentKey = self.gallery?.id
//                    if (userKey == currentKey) {
//                        ref.child(userKey).updateChildValues(values)
//                        self.updateLabel.isHidden = false
//                    }
//                }
//            }
//        }
//        
//    }
//    
//    let captionView: UITextView = {
//        let textView = UITextView()
//        textView.font = UIFont.systemFont(ofSize: 14)
//        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
//        textView.textColor = UIColor.black
//        textView.layer.cornerRadius = 5
//        return textView
//    }()
//    
//    let locationTextField: UITextField = {
//        let text = UITextField()
//        text.placeholder = "Add Location"
//        text.font = UIFont.systemFont(ofSize: 14)
//        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
//        text.textColor = UIColor.black
//        text.layer.cornerRadius = 5
//        return text
//    }()
//    
//    let updateLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = UIColor.red
//        label.text = "Update was successful"
//        return label
//    }()

}
