//
//  ChatCell.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {

    //MARK: - Properties
    var message: Message? {
        didSet {
            configure()
        }
    }
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    //MARK: - Lifecycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        constrainViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func setupViews() {
        addSubview(profileImage)
        addSubview(bubbleContainer)
        bubbleContainer.addSubview(textView)
    }
    
    func constrainViews() {
        profileImage.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 20)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom: 4, paddingRight: 10)
        
    }
    
    func configure() {
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.messageTextColor
        textView.text = message.text
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        profileImage.isHidden = viewModel.shouldHideProfileImage
    }
    
    //MARK: - Views
    private let profileImage: CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "image_background")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.layer.cornerRadius = 25
        return image
    }()
    
    private let textView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .clear
        text.font = UIFont.systemFont(ofSize: 16)
        text.isScrollEnabled = false
        text.isEditable = false
        return text
    }()
    
    private let bubbleContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orangeColor()
        return view
    }()
    
}
