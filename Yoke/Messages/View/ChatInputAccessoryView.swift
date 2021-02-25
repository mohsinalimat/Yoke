//
//  ChatInputAccessoryView.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class ChatInputAccessoryView: UIView {
    
    //MARK: - Properties
    
    //MARK: - Lifecycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        constrainViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func setupViews() {
        backgroundColor = UIColor.black
        autoresizingMask = .flexibleHeight
        addSubview(sendButton)
        addSubview(messageInputTextView)
    }

    func constrainViews() {
        sendButton.anchor(top: messageInputTextView.topAnchor, left: messageInputTextView.rightAnchor, bottom: messageInputTextView.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 75)
        messageInputTextView.anchor(top: safeAreaLayoutGuide.topAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: nil, right: sendButton.rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 50)
    }
    
    //MARK: - Helper Functions
    @objc func handleSendMessage() {
        print("hanle send message")
    }
    
    //MARK: - Views
    private let messageInputTextView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 14)
        text.isScrollEnabled = false
        return text
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
}
