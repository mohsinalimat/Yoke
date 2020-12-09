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

class AddPhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupNavTitleAndBarButtonItems()
        setupViews()
    }
    
    let tipView: UITextView = {
        let text = UITextView()
        text.text = "Upload a high quality image for better results!"
        text.font = UIFont.systemFont(ofSize: 14)
        text.textAlignment = .center
        text.textColor = UIColor.mainColor()
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
        button.backgroundColor = UIColor.mainColor()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(handleChange), for: .touchUpInside)
        return button
    }()
    
    let navView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor()
        return view
    }()
    
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
    
    func setupViews() {
        view.addSubview(photoImageView)
        view.addSubview(tipView)
        view.addSubview(photosButton)
        
        photoImageView.anchor(top: navView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width, height: view.frame.width)
        
        tipView.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)

        photosButton.anchor(top: tipView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 50)
    }
    
    @objc func handleCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//class AddPhotoVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    
//    let cellId = "cellId"
//    let headerId = "headerId"
//    var user: User?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView?.register(AddPhotoHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//        collectionView?.register(AddPhotoCell.self, forCellWithReuseIdentifier: cellId)
//        
//        setupNavTitleAndBarButtonItems()
//        fetchPhotos()
//    }
//    
//    var selectedImage: UIImage?
//    var images = [UIImage]()
//    var assets = [PHAsset]()
//    
//    fileprivate func asssetsFetchOptions() -> PHFetchOptions {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.fetchLimit = 500
//        let sortDescriptor = NSSortDescriptor(key: Constants.CreationDate, ascending: false)
//        fetchOptions.sortDescriptors = [sortDescriptor]
//        return fetchOptions
//    }
//    
//    fileprivate func fetchPhotos() {
//        
//        let allPhotos = PHAsset.fetchAssets(with: .image, options: asssetsFetchOptions())
//        
//        DispatchQueue.global(qos: .background).async {
//            allPhotos.enumerateObjects ({ (asset, count, stop) in
//                let imageManager = PHImageManager.default()
//                let targetSize = CGSize(width: 200, height: 200)
//                let options = PHImageRequestOptions()
//                options.isSynchronous = true
//                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options, resultHandler: { (image, info) in
//                    if let image = image {
//                        self.images.append(image)
//                        self.assets.append(asset)
//                        if self.selectedImage == nil {
//                            self.selectedImage = image
//                        }
//                    }
//                
//                    if count == allPhotos.count - 1 {
//                        DispatchQueue.main.async {
//                            self.collectionView?.reloadData()
//                        }
//                    }
//                    
//                })
//            })
//        }
//
//    }
//    
//    @objc func handlePhotoLibrary() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true
//        
//        present(imagePickerController, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImage = editedImage
//            
//        } else if let originalImage =
//            info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            selectedImage = originalImage
//        }
//        //        coverImageView.image = selectedImage
//        
//        dismiss(animated: true, completion: nil)
//    }
//    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.isTranslucent = false
//    }
//    
//    func setupNavTitleAndBarButtonItems() {
//        navigationItem.title = "Select Photo"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
//    }
//    
//    
//    @objc func handleNext() {
//        let shareVC = SharePhotoVC()
//        shareVC.selectedImage = header?.photoImageView.image
//        navigationController?.pushViewController(shareVC, animated: true)
//    }
//    
//    @objc func handleCancel() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    var header: AddPhotoHeaderCell?
//    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AddPhotoHeaderCell
//
//        self.header = header
//
//        header.changeCoverButton.addTarget(self, action: #selector(handlePhotoLibrary), for: .touchUpInside)
//
//        header.photoImageView.image = selectedImage
//
//        if let selectedImage = selectedImage {
//            if let index = self.images.index(of: selectedImage) {
//                let selectedAsset = self.assets[index]
//                let imageManager = PHImageManager.default()
//                let targetSize = CGSize(width: 600, height: 600)
//                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
//                    header.photoImageView.image = image
//                })
//            }
//        }
//
//        return header
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return images.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddPhotoCell
//        cell.photoImageView.image = images[indexPath.item]
//        return cell
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.selectedImage = images[indexPath.item]
//        self.collectionView?.reloadData()
//        
//        let indexPath = IndexPath(item: 0, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        let width = view.frame.width
//        return CGSize(width: width, height: width)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.init(top: 3, left: 0, bottom: 0, right: 0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (view.frame.width - 3) / 4
//        return CGSize(width: width, height: width)
//    }
//
//}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
