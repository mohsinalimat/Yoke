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
        bubbleContainer.anchor(top: safeAreaLayoutGuide.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 20)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 10, paddingBottom: 4, paddingRight: 10)
        
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
        text.text = "yo"
        text.backgroundColor = .clear
        text.font = UIFont.boldSystemFont(ofSize: 16)
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
