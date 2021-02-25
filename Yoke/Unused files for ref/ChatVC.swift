//
//  ChatVC.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation
import AVKit

//class ChatVC: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChatCellDelegate, MessageInputAccessoryViewDelegate, chatHeaderDelegate {
//
//    func viewDetails(user: User) {
//        print("details")
//    }
//
//
//
//    let cellId = "Cell"
//    let headerId = "headerId"
//    var userId: String?
//    var event: Event?
//    var user: User? {
//        didSet {
//            userId = user?.uid
//            self.navigationItem.title = user?.username
//            observeMessages()
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.white
//        collectionView?.contentInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 20, right: 5)
//        collectionView?.alwaysBounceVertical = true
//        collectionView?.backgroundColor = UIColor.white
//        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView?.keyboardDismissMode = .interactive
//        setupKeyboardObservers()
//        print("user is \(userId)")
//        //header
//        collectionView?.register(ChatHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//
//    }
//
//    @objc func backButton() {
//        navigationController?.popViewController(animated: true)
//    }
//
//    let navView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.orangeColor()
//        return view
//    }()
//
//    @objc func handleDismiss() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        tabBarController?.tabBar.isHidden = true
//        self.navigationController?.navigationBar.isTranslucent = false
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.isHidden = false
//    }
//
//    var messages = [Message]()
//    func observeMessages() {
//
//        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.uid else {
//            return
//        }
//
//        userId = toId
//        let userMessagesRef = Database.database().reference().child(Constants.UserMessages).child(uid).child(toId)
//        userMessagesRef.observe(.childAdded, with: { (snapshot) in
//
//            let messageId = snapshot.key
//            let messagesRef = Database.database().reference().child(Constants.Messages).child(messageId)
//            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                guard let dictionary = snapshot.value as? [String: AnyObject] else {
//                    return
//                }
//
//                self.messages.append(Message(dictionary: dictionary))
//                DispatchQueue.main.async(execute: {
//                    self.collectionView?.reloadData()
//                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
//                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
//                })
//
//            }, withCancel: nil)
//
//        }, withCancel: nil)
//    }
//
//    func handleMessages() {
//        let messageVC = MessageVC()
//        let navController = UINavigationController(rootViewController: messageVC)
//        present(navController, animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
//    }
//
//    lazy var containerView: MessageInputAccessoryView = {
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        let messageInputAccessoryView = MessageInputAccessoryView(frame: frame)
//        messageInputAccessoryView.delegate = self
//        return messageInputAccessoryView
//    }()
//
//    func addMediaSubmit(button: UIButton) {
//        handleAddImageVideo()
//    }
//
//    override var inputAccessoryView: UIView? {
//        get {
//            return containerView
//        }
//    }
//
//    override var canBecomeFirstResponder : Bool {
//        return true
//    }
//
//    func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//    }
//
//    var containerViewBottomAnchor: NSLayoutConstraint?
//
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func handleKeyboardWillShow(_ notification: Notification) {
//        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
//        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//
//        containerViewBottomAnchor?.constant = -keyboardFrame!.height
//        UIView.animate(withDuration: keyboardDuration!, animations: {
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func handleKeyboardWillHide(_ notification: Notification) {
//        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//
//        containerViewBottomAnchor?.constant = 0
//        UIView.animate(withDuration: keyboardDuration!, animations: {
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    //MARK: CollectionView
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
//
//        cell.chatLogController = self
//
//        let message = messages[indexPath.item]
//        cell.delegate = self
//        cell.textView.text = message.text
//
//        setupCell(cell: cell, message: message)
//
//        if let text = message.text {
//            cell.bubbleWidthAnchor?.constant = estimateFrameForTextForText(text: text).width + 32
//            cell.textView.isHidden = false
//        } else if message.imageUrl != nil {
//            cell.bubbleWidthAnchor?.constant = 200
//            cell.textView.isHidden = true
//        }
//
//        cell.backgroundColor = UIColor.white
//        cell.playButton.isHidden = message.videoUrl == nil
//
//        return cell
//    }
//
//    private func setupCell(cell: ChatCell, message: Message) {
//
//        if let profileImageUrl = self.user?.profileImageUrl {
//            cell.profileImageView.loadImage(urlString: profileImageUrl)
//        }
//
//        if message.fromId == Auth.auth().currentUser?.uid {
//            cell.bubbleView.backgroundColor = UIColor.orangeColor()
//            cell.textView.textColor = UIColor.white
//            cell.bubbleViewRightAnchor?.isActive = true
//            cell.bubbleViewLeftAnchor?.isActive = false
//            cell.profileImageView.isHidden = true
//            cell.rightTimeLabel.isHidden = false
//            cell.leftTimeLabel.isHidden = true
//        } else {
//            cell.bubbleView.backgroundColor = UIColor.yellowColor()
//            cell.textView.textColor = UIColor.white
//            cell.bubbleViewRightAnchor?.isActive = false
//            cell.bubbleViewLeftAnchor?.isActive = true
//            cell.profileImageView.isHidden = false
//            cell.rightTimeLabel.isHidden = true
//            cell.leftTimeLabel.isHidden = false
//        }
//
//        if let messageImageUrl = message.imageUrl {
//            cell.messageImageView.loadImage(urlString: messageImageUrl)
//            cell.messageImageView.isHidden = false
//            cell.bubbleView.backgroundColor = UIColor.clear
//        } else {
//            cell.messageImageView.isHidden = true
//        }
//
//        let dateFormatter = DateFormatter()
//        let calendar = Calendar(identifier: .gregorian)
//        dateFormatter.doesRelativeDateFormatting = true
//
//        if calendar.isDateInToday((message.creationDate)!) {
//            dateFormatter.timeStyle = .short
//            dateFormatter.dateStyle = .none
//        } else if calendar.isDateInYesterday((message.creationDate)!){
//            dateFormatter.timeStyle = .short
//            dateFormatter.dateStyle = .medium
//            //            dateFormatter.dateFormat = "MMM d, h:mm a"
//
//        } else if calendar.compare(Date(), to: (message.creationDate)!, toGranularity: .weekOfYear) == .orderedSame {
//            let weekday = calendar.dateComponents([.weekday], from: (message.creationDate)!).weekday ?? 0
//            return print(weekday)
//
//            //                return dateFormatter.weekdaySymbols[weekday-1]
//        } else {
//            dateFormatter.timeStyle = .short
//            dateFormatter.dateStyle = .medium
//        }
//
//        cell.rightTimeLabel.text = dateFormatter.string(from: (message.creationDate)!)
//        cell.leftTimeLabel.text = dateFormatter.string(from: (message.creationDate)!)
//
//    }
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        collectionView?.collectionViewLayout.invalidateLayout()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        var height: CGFloat = 80
//        let message = messages[indexPath.item]
//
//        if let text = message.text {
//            height = estimateFrameForTextForText(text: text).height + 20
//        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
//            height = CGFloat(imageHeight / imageWidth * 200)
//        }
//        let width = UIScreen.main.bounds.width
//        return CGSize(width: width, height: height)
//    }
//
//    private func estimateFrameForTextForText(text: String) -> CGRect {
//        let size = CGSize(width: 200, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
//        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 30
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ChatHeaderCell
//
//        header.user = self.user
//        header.delegate = self
//
//        header.layer.cornerRadius = 2
//        header.layer.borderWidth = 0.2
//        header.layer.borderColor = UIColor.lightGray.cgColor
//
//        header.layer.backgroundColor = UIColor.white.cgColor
//        header.layer.shadowColor = UIColor.gray.cgColor
//        header.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
//        header.layer.shadowRadius = 2.0
//        header.layer.shadowOpacity = 0.3
//        header.layer.masksToBounds = false
//
//
//        return header
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.size.width, height: 200)
//    }
//
//    //MARK: Handle sending Images & Videos
//    func didSubmit(for message: String) {
//       let properties = [Constants.PostText: message]
//        sendMessageWithProperties(properties as [String : AnyObject])
//        self.containerView.clearMessageTextField()
//    }
//
//    @objc func handleAddImageVideo() {
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.allowsEditing = true
//        imagePickerController.delegate = self
//        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
//        //        imagePickerController.cameraOverlayView
//
//
//        present(imagePickerController, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
//
//
//        if let videoUrl = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.mediaURL)] as? URL {
//            handleVideoSelectedForUrl(videoUrl)
//        } else {
//            handleImageSelectedForInfo(info as [String : AnyObject])
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
//
//    fileprivate func handleVideoSelectedForUrl(_ url: URL) {
//        let filename = UUID().uuidString + ".mov"
//        let ref = Storage.storage().reference().child(Constants.MessageMovies).child(filename)
//        let uploadTask = ref.putFile(from: url, metadata: nil, completion: { (_, err) in
//            if let err = err {
//                print("Failed to upload movie:", err)
//                return
//            }
//
//            ref.downloadURL(completion: { (downloadUrl, err) in
//                if let err = err {
//                    print("Failed to get download url:", err)
//                    return
//                }
//
//                guard let downloadUrl = downloadUrl else { return }
//
//                if let thumbnailImage = self.thumbnailImageForFileUrl(url) {
//
//                    self.uploadToDatabase(image: thumbnailImage, completion: { (imageUrl) in
//                        let properties: [String: AnyObject] = [Constants.ImageUrl: imageUrl as AnyObject, Constants.Width: thumbnailImage.size.width as AnyObject, Constants.Height: thumbnailImage.size.height as AnyObject, Constants.VideoUrl: downloadUrl.absoluteString as AnyObject]
//                        self.sendMessageWithProperties(properties)
//                    })
//                }
//
//            })
//        })
//
//        uploadTask.observe(.progress) { (snapshot) in
//            if let completedUnitCount = snapshot.progress?.completedUnitCount {
//                print(completedUnitCount)
////                self.navigationItem.title = String(completedUnitCount)
//            }
//        }
//
//        uploadTask.observe(.success) { (snapshot) in
//            print("success")
//        }
//
//    }
//
//    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
//        let asset = AVAsset(url: fileUrl)
//        let imageGenerator = AVAssetImageGenerator(asset: asset)
//
//        do {
//
//            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
//            return UIImage(cgImage: thumbnailCGImage)
//
//        } catch let err {
//            print(err)
//        }
//
//        return nil
//    }
//
//    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
//        var selectedImageFromPicker: UIImage?
//
//        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            selectedImageFromPicker = editedImage
//        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//
//            selectedImageFromPicker = originalImage
//        }
//
//        if let selectedImage = selectedImageFromPicker {
//            uploadToDatabase(image: selectedImage, completion: { (imageUrl) in
//                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
//            })
//        }
//
//    }
//
//    private func uploadToDatabase(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
//        let imageName = UUID().uuidString
//        let ref = Storage.storage().reference().child(Constants.MessageImages).child(imageName)
//
//        if let uploadData = image.jpegData(compressionQuality: 0.2) {
//            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
//
//                if error != nil {
//                    print("Failed to upload image:", error!)
//                    return
//                }
//
//                ref.downloadURL(completion: { (url, err) in
//                    if let err = err {
//                        print(err)
//                        return
//                    }
//
//                    completion(url?.absoluteString ?? "")
//                })
//
//            })
//        }
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
//        let properties: [String: AnyObject] = [Constants.ImageUrl: imageUrl as AnyObject, Constants.Width: image.size.width as AnyObject, Constants.Height: image.size.height as AnyObject]
//        sendMessageWithProperties(properties)
//    }
//
//    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
//        let ref = Database.database().reference().child(Constants.Messages)
//        let childRef = ref.childByAutoId()
//        guard let toId = userId else { return }
//        let fromId = Auth.auth().currentUser!.uid
//        let timestamp = Int(Date().timeIntervalSince1970)
//
//        var values: [String: AnyObject] = [Constants.ToId: toId as AnyObject, Constants.FromId: fromId as AnyObject, Constants.CreationDate: timestamp as AnyObject]
//
//        properties.forEach({values[$0] = $1})
//
//        childRef.updateChildValues(values) { (error, ref) in
//            if error != nil {
//                print(error!)
//                return
//            }
//
//            let messageId = childRef.key
//
//            let userMessagesRef = Database.database().reference().child(Constants.UserMessages).child(fromId).child(toId).child(messageId!)
//
//            userMessagesRef.setValue(1)
//
//            let recipientUserMessagesRef = Database.database().reference().child(Constants.UserMessages).child(toId).child(fromId).child(messageId!)
//            recipientUserMessagesRef.setValue(1)
//        }
//    }
//
//
//    func didPlayVideo(for cell: ChatCell) {
//        guard let indexPath = collectionView?.indexPath(for: cell) else {return}
//        let message = self.messages[indexPath.item]
//        if let videoUrlString = message.videoUrl, let url = URL(string: videoUrlString) {
//            let player = AVPlayer(url: url)
//            let playerViewController = AVPlayerViewController()
//            playerViewController.player = player
//            self.present(playerViewController, animated: true) {
//                playerViewController.player!.play()
//            }
//        }
//    }
//
//    var startingFrame: CGRect?
//    var blackBackgroundView: UIView?
//    var startingImageView: UIImageView?
//
//    func performZoomInForStartingImageView(startingImageView: UIImageView) {
//
//        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
//
//        let zoomingImageView = UIImageView(frame: startingFrame!)
//        zoomingImageView.backgroundColor = .black
//        zoomingImageView.image = startingImageView.image
//        zoomingImageView.isUserInteractionEnabled = true
//        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
//
//        if let keyWindow = UIApplication.shared.keyWindow {
//
//            blackBackgroundView = UIView(frame: keyWindow.frame)
//            blackBackgroundView?.backgroundColor = UIColor.black
//            blackBackgroundView?.alpha = 0
//            keyWindow.addSubview(blackBackgroundView!)
//
//            keyWindow.addSubview(zoomingImageView)
//
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
//
//                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
//                self.blackBackgroundView?.alpha = 1
////                self.inputContainerView.alpha = 0
//                self.containerView.alpha = 0
//
//                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
//                zoomingImageView.center = keyWindow.center
//
//            }, completion: nil)
//
//        }
//    }
//
//    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
//        if let zoomOutImageView = tapGesture.view {
//            //need to animate back out to controller
//            zoomOutImageView.layer.cornerRadius = 16
//            zoomOutImageView.clipsToBounds = true
//
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//
//                zoomOutImageView.frame = self.startingFrame!
//                self.blackBackgroundView?.alpha = 0
//                self.containerView.alpha = 1
//
//            }, completion: { (completed) in
//                zoomOutImageView.removeFromSuperview()
//                self.startingImageView?.isHidden = false
//            })
//        }
//    }
//
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
//    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
//}
//
//// Helper function inserted by Swift 4.2 migrator.
//fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
//    return input.rawValue
//}
