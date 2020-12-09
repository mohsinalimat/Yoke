//
//  CustomCoverImageVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 3/12/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase

class CustomCoverImageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var user: User? {
        didSet {
            guard let coverImageUrl = user?.ProfileCoverUrl else {return}
            coverImageView.loadImage(urlString: coverImageUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupNavTitleAndBarButtonItems()
        setupViews()
//        getUserCover()
    }
    
    func getUserCover() {
        Database.database().reference().child(Constants.Users).child(Auth.auth().currentUser?.uid ?? "").observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let coverImageUrl = value?[Constants.ProfileCoverUrl] as? String
            self.coverImageView.loadImage(urlString: coverImageUrl!)
            
        }
    }
    
    let tipView: UITextView = {
        let text = UITextView()
        text.text = "Upload a high quality image for better results!"
        text.font = UIFont.systemFont(ofSize: 14)
        text.textAlignment = .center
        text.textColor = UIColor.orangeColor()
        text.backgroundColor = UIColor.white
        return text
    }()
    
    let coverImageView: CustomImageView = {
        let image = CustomImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "no_post_background")
        return image
    }()
    
    lazy var changeCoverButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 2
        button.setTitle("Choose photo from Library", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.orangeColor()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
        return button
    }()
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
    var selectedImage: UIImage?
    
    @objc func handleChange() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            coverImageView.image = editedImage
            
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            coverImageView.image = originalImage
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Select Photo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleUpdate))
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(handleCancel))
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    func setupViews() {
        view.addSubview(coverImageView)
        view.addSubview(tipView)
        view.addSubview(changeCoverButton)
        
        coverImageView.anchor(top: navView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: 250)
        
        tipView.anchor(top: coverImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)
        
        changeCoverButton.anchor(top: tipView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)
    }
    
    @objc func handleCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    @objc func handleUpdate() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let coverImage = coverImageView.image else {return}
        let bannerStorageRef = Storage.storage().reference().child(Constants.ProfileCoverUrl).child("\(coverImage).jpg")
        if let uploadData = coverImage.jpegData(compressionQuality: 0.5) {
            bannerStorageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("print error")
                }
                
                bannerStorageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to retrieve downloadURL:", err)
                        return
                    }
                    guard let coverImageUrl = downloadURL?.absoluteString else { return }
                    let values = [Constants.ProfileCoverUrl: coverImageUrl]
                    DataService.instance.updateUserValues(uid: uid, values: values as [String : AnyObject])
                    NotificationCenter.default.post(name: CustomCoverImageVC.updateNotificationName, object: nil)
                })
                
            })
        }
        let homeVC = HomeVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

