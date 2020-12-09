//
//  ChangeProfileImageVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Photos
import Firebase

class ChangeProfileImageVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(AddPhotoHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(AddPhotoCell.self, forCellWithReuseIdentifier: cellId)

        setupNavTitleAndBarButtonItems()    
    }
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
    var selectedImage: UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]()
    
    fileprivate func asssetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 500
        let sortDescriptor = NSSortDescriptor(key: Constants.CreationDate, ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    fileprivate func fetchPhotos() {
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: asssetsFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects ({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    
                })
            })
        }
        
    }
    
    func setupNavTitleAndBarButtonItems() {
        navigationItem.title = "Select Photo"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleUpdate))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:  #selector(handleCancel))
        view.addSubview(navView)
        navView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    }
    
    @objc func handleCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    var header: AddPhotoHeaderCell?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AddPhotoHeaderCell
        
        self.header = header
        
        header.photoImageView.image = selectedImage
        
        if let selectedImage = selectedImage {
            if let index = self.images.index(of: selectedImage) {
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    header.photoImageView.image = image
                })
            }
        }
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddPhotoCell
        cell.photoImageView.image = images[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 3, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    static let updateNotificationName = NSNotification.Name(rawValue: "Update")
    @objc func handleUpdate() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let profileImage = selectedImage else {return}
        let StorageRef = Storage.storage().reference().child(Constants.ProfileImages).child("\(profileImage).jpg")
        if let uploadData = profileImage.jpegData(compressionQuality: 0.5) {
            StorageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("print error")
                }
                
                StorageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to retrieve downloadURL:", err)
                        return
                    }
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    let values = [Constants.ProfileImageUrl: profileImageUrl]
                    DataService.instance.updateUserValues(uid: uid, values: values as [String : AnyObject])
                    NotificationCenter.default.post(name: ChangeProfileImageVC.updateNotificationName, object: nil)
                })
//
//                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                    let values = [Constants.ProfileImageUrl: profileImageUrl]
//                    DataService.instance.updateUserValues(uid: uid, values: values as [String : AnyObject])
//                    NotificationCenter.default.post(name: ChangeProfileImageVC.updateNotificationName, object: nil)
//                }
                
//                FIRDatabase.userIsChef(userKey: uid) { (isChef) in
//                    if isChef == true {
//                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                            let values = [Constants.ProfileImageUrl: profileImageUrl]
//                            DataService.instance.updateChefValues(uid: uid, values: values as [String : AnyObject])
//                            NotificationCenter.default.post(name: ChangeProfileImageVC.updateNotificationName, object: nil)
//                        }
//                    } else {
//                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                            let values = [Constants.ProfileImageUrl: profileImageUrl]
//                            DataService.instance.updateUserValues(uid: uid, values: values as [String : AnyObject])
//                            NotificationCenter.default.post(name: ChangeProfileImageVC.updateNotificationName, object: nil)
//                        }
//                    }
//                }
            
            })
        }
//        FIRDatabase.userIsChef(userKey: uid) { (isChef) in
//            if isChef == true {
//                self.saveChef()
//            } else {
//                self.saveUser()
//            }
//        }
        let homeVC = HomeVC(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(homeVC, animated: true)
        
    }
    
//    func saveChef() {
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
//        guard let profileImage = selectedImage else {return}
//        let StorageRef = FIRStorage.storage().reference().child(Constants.ProfileImages).child("\(profileImage).jpg")
//        if let uploadData = profileImage.jpegData(compressionQuality: 0.5) {
//            StorageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
//                if error != nil {
//                    print("print error")
//                }
//
//                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                    let values = [Constants.ProfileImageUrl: profileImageUrl]
//                    DataService.instance.updateChefValues(uid: uid, values: values as [String : AnyObject])
//                }
//            })
//        }
//    }
    
    func saveUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let profileImage = selectedImage else {return}
        let StorageRef = Storage.storage().reference().child(Constants.ProfileImages).child("\(profileImage).jpg")
        if let uploadData = profileImage.jpegData(compressionQuality: 0.5) {
            StorageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print("print error")
                }
                StorageRef.downloadURL(completion: { (downloadURL, err) in
                    if let err = err {
                        print("Failed to retrieve downloadURL:", err)
                        return
                    }
                    guard let profileImageUrl = downloadURL?.absoluteString else { return }
                    
                    let values = [Constants.ProfileImageUrl: profileImageUrl]
                    DataService.instance.updateUserValues(uid: uid, values: values as [String : AnyObject])
                })
                
//                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//                    let values = [Constants.ProfileImageUrl: profileImageUrl]
//                    DataService.instance.updateUserValues(uid: uid, values: values as [String : AnyObject])
//                }
            })
        }
    }
    
}
