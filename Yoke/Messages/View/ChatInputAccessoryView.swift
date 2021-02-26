//
//  ChatInputAccessoryView.swift
//  Yoke
//
//  Created by LAURA JELENICH on 2/25/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

protocol ChatInputAccessoryViewDelegate: class {
    func inputView(_ inputView: ChatInputAccessoryView, wantsToSend message: String)
}

class ChatInputAccessoryView: UIView {
    
    //MARK: - Properties
    weak var delegate: ChatInputAccessoryViewDelegate?
    
    //MARK: - Lifecycle Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        constrainViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        backgroundColor = UIColor.white
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowColor = UIColor.lightGray.cgColor
        autoresizingMask = .flexibleHeight
        addSubview(swipeIndicator)
        addSubview(sendButton)
        addSubview(messageInputTextView)
    }

    func constrainViews() {
        swipeIndicator.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: frame.width / 3, height: 5)
        swipeIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sendButton.anchor(top: messageInputTextView.topAnchor, left: messageInputTextView.rightAnchor, bottom: messageInputTextView.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 75)
        messageInputTextView.anchor(top: swipeIndicator.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 5, paddingRight: 5)
    }
    
    //MARK: - Helper Functions
    func clearText() {
        messageInputTextView.text = ""
        messageInputTextView.placeholder = "Enter message..."
    }
    
    //MARK: - Selectors
    @objc func handleSendMessage() {
        guard let text = messageInputTextView.text else { return }
        delegate?.inputView(self, wantsToSend: text)
    }
    
    //MARK: - Views
    let swipeIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        return view
    }()
    
    let messageInputTextView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 14)
        text.isScrollEnabled = false
        text.backgroundColor = .white
        text.layer.cornerRadius = 4
        text.textColor = .darkGray
        text.placeholder = "Enter message..."
        return text
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleSendMessage), for: .touchUpInside)
        return button
    }()
}
