//
//  ChatViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import Firebase
import FirebaseAuth
import MessageKit
import FirebaseFirestore
import SDWebImage

//https://ibjects.medium.com/simple-text-chat-app-using-firebase-in-swift-5-b9fa91730b6c

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

    var currentUser = Auth.auth().currentUser
    var user2UID: String?
    var message: Message?
    var currentUserUid = Auth.auth().currentUser?.uid
    var user: User? {
        didSet {
            user2UID = user?.uid
        }
    }

    private var docReference: DocumentReference?

    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadChat()
        setupMessage()
        setupTitleName()
    }

    //MARK: - Helper functions
    
    func setupTitleName() {
        guard let uid = self.user2UID else { return }
        UserController.shared.fetchUserWithUID(uid: uid) { (user) in
            self.navigationItem.title = user.username
        }
    }
    
    func setupMessage() {
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = UIColor.gray
        messageInputBar.sendButton.setTitleColor(UIColor.orangeColor(), for: .normal)

        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

    // MARK: - Custom messages handlers
    func createNewChat() {
        guard let currentUserUid = self.currentUser?.uid, let user2Uid =  self.user2UID else { return }
        let users = [currentUserUid, user2Uid]
        let data: [String: Any] = [Constants.Users:users]
        
        let currentUserData: [String: Any] = ["currentUser": currentUserUid]
        
        let user2UidData: [String: Any] = ["user2Uid": user2Uid]

        let db = Firestore.firestore().collection(Constants.Messages)
         db.addDocument(data: data) { (error) in
             if let error = error {
                 print("Unable to create chat! \(error)")
                 return
             } else {
                print("line 78")
                 self.loadChat()
             }
         }
        
        let userDb = Firestore.firestore().collection(Constants.UserMessages)
        userDb.addDocument(data: currentUserData) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                print("line 89")
                self.loadChat()
            }
        }
        userDb.addDocument(data: user2UidData) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                print("line 98")
                self.loadChat()
            }
        }
    }

    func loadChat() {
        print("load chat")
        let db = Firestore.firestore().collection(Constants.Messages)
            .whereField(Constants.Users, arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }

                if queryCount == 0 {
                    self.createNewChat()
                }
                else if queryCount >= 1 {
                    for doc in chatQuerySnap!.documents {
                        let chat = Chat(dictionary: doc.data())
                        guard let toUser = self.user2UID else { return }
                        if (chat?.users.contains(toUser))! {
                            self.docReference = doc.reference
                            doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                self.messages.removeAll()
                                    for message in threadQuery!.documents {
                                        guard let msg = Message(dictionary: message.data()) else { return }
                                        print(message.data())
                                        self.messages.append(msg)
                                        print("Data: \(msg.content ?? "There are currently no messages")")
                                    }
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToLastItem(animated: true)
                            }
                            })
                            return
                        }
                    }
                    self.createNewChat()
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }


    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }

    private func save(_ message: Message) {

        let data: [String: Any] = [
            Constants.Content: message.content,
            Constants.Created: message.created,
            Constants.Id: message.id,
            Constants.SenderID: message.senderID,
            "senderName": message.senderName,
            Constants.ToId: message.toId
        ]

        docReference?.collection(Constants.Thread).addDocument(data: data, completion: { (error) in

            if let error = error {
                print("Error Sending message: \(error)")
                return
            }

            self.messagesCollectionView.scrollToLastItem()

        })
    }

    // MARK: - InputBarAccessoryViewDelegate
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard let currentUserUid = currentUser?.uid, let toId = self.user2UID else { return }
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUserUid, senderName: "", toId: toId)
            insertNewMessage(message)
            save(message)
            inputBar.inputTextView.text = ""
            messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }

    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        return Sender(senderId: currentUserUid ?? "", displayName: "nil")
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        print("Message count 204 \(messages[indexPath.section])")
        return messages[indexPath.section]

    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        print("Message count 209 \(messages.count)")
        if messages.count == 0 {
            return 0
        } else {
            return messages.count
        }
    }

    // MARK: - MessagesLayoutDelegate
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }

    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        guard let blue = UIColor.yellowColor(), let orange = UIColor.orangeColor() else { return UIColor() }
        return isFromCurrentSender(message: message) ? blue : orange
    }

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .white
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {

        guard let currentUserUid = currentUser?.uid else { return }
        if message.sender.senderId == currentUserUid {
            Storage.storage().reference().child("profileImage/\(currentUserUid)").getData(maxSize: 2 * 1024 * 1024) { data, error in
                if error == nil, let data = data {
                    avatarView.image = UIImage(data: data)
                }
            }
        } else {
            guard let user2 = self.user2UID else { return }
            Storage.storage().reference().child("profileImage/\(user2)").getData(maxSize: 2 * 1024 * 1024) { data, error in
                if error == nil, let data = data {
                    avatarView.image = UIImage(data: data)
                }
            }
        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

