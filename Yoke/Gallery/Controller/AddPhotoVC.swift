//
//  AddPhotoVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import Photos

class AddPhotoVC: UIViewController {
    
    var selectedImage: UIImage?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupNavTitleAndBarButtonItems()
        setupViews()
    }
    
    func setupViews() {
        view.addSubview(photoImageView)
        view.addSubview(tipView)
        view.addSubview(photosButton)
        constrainViews()
    }
    
    func constrainViews() {
        photoImageView.anchor(top: navView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width)
        
        tipView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)

        photosButton.anchor(top: tipView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)
    }
    
    @objc func handleChange() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        let shareVC = SharePhotoVC()
        shareVC.selectedImage = photoImageView.image
        navigationController?.pushViewController(shareVC, animated: true)
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Select Photo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(handleCancel))
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func handleCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Views
    let tipView: UITextView = {
        let text = UITextView()
        text.text = "Upload a high quality image for better results!"
        text.font = UIFont.systemFont(ofSize: 14)
        text.textAlignment = .center
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.white
        return text
    }()
    
    let photoImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
//        image.contentMode = .scaleAspectFill
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "no_post_background")
        return image
    }()
    
    lazy var photosButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 2
        button.setTitle("Choose photo from Library", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
        return button
    }()
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
}

extension AddPhotoVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            photoImageView.image = editedImage
            
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            photoImageView.image = originalImage
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
