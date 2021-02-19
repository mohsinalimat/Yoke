//
//  ChatCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit
import AVFoundation

protocol ChatCellDelegate {
    func didPlayVideo(for cell: ChatCell)
}
class ChatCell: UICollectionViewCell {
    
//    var message: Message?
//    var chatLogController: ChatVC?
//    var delegate: ChatCellDelegate?
//    
//    lazy var playButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        let image = UIImage(named: "play")
//        button.tintColor = UIColor.white
//        button.setImage(image, for: UIControl.State())
//        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
//        return button
//    }()
//    
//    @objc func handlePlay() {
//        delegate?.didPlayVideo(for: self)
//    }
//    
//    let textView: UITextView = {
//        let textV = UITextView()
//        textV.font = UIFont.systemFont(ofSize: 16)
//        textV.translatesAutoresizingMaskIntoConstraints = false
//        textV.backgroundColor = UIColor.clear
//        textV.textColor = UIColor.white
//        textV.isEditable = false
//        return textV
//    }()
//    
//    let bubbleView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5
//        view.layer.masksToBounds = true
//        return view
//    }()
//    
//    let profileImageView: CustomImageView = {
//        let imageView = CustomImageView()
//        imageView.image = UIImage(named: "chef-in-uniform")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 16
//        imageView.layer.masksToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//    
//    lazy var messageImageView: CustomImageView = {
//        let imageView = CustomImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 5
//        imageView.layer.masksToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoom)))
//        return imageView
//    }()
//    
//    @objc func handleZoom(tapGesture: UITapGestureRecognizer) {
//        if message?.videoUrl != nil {
//            return
//        }
//        
//        if let imageView = tapGesture.view as? UIImageView {
//            self.chatLogController?.performZoomInForStartingImageView(startingImageView: imageView)
//        }
//    }
//    
//    let rightTimeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.textColor = UIColor.lightGray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let leftTimeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 10)
//        label.textColor = UIColor.lightGray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    var bubbleWidthAnchor: NSLayoutConstraint?
//    var bubbleViewRightAnchor: NSLayoutConstraint?
//    var bubbleViewLeftAnchor: NSLayoutConstraint?
//    var timeViewRightAnchor: NSLayoutConstraint?
//    var timeViewLeftAnchor: NSLayoutConstraint?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        addSubview(bubbleView)
//        addSubview(textView)
//        addSubview(profileImageView)
//        
//        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 10).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
//        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        
//        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
//        bubbleViewRightAnchor?.isActive = true
//        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10)
//        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        
//        addSubview(rightTimeLabel)
//        rightTimeLabel.anchor(top: bubbleView.bottomAnchor, left: nil, bottom: nil, right: bubbleView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//        addSubview(leftTimeLabel)
//        leftTimeLabel.anchor(top: bubbleView.bottomAnchor, left: bubbleView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
//        
//        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
//        bubbleWidthAnchor?.isActive = true
//        
//        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        
//        bubbleView.addSubview(messageImageView)
//        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
//        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
//        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
//        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
//        
//        bubbleView.addSubview(playButton)
//        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
//        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
//        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 4).isActive = true
//        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
