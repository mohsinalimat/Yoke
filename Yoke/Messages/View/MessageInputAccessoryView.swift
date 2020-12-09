//
//  MessageInputAccessoryView.swift
//  FooD
//
//  Created by LAURA JELENICH on 3/29/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit

protocol MessageInputAccessoryViewDelegate {
    func didSubmit(for message: String)
    func addMediaSubmit(button: UIButton)
}

class MessageInputAccessoryView: UIView {
    
    var delegate: MessageInputAccessoryViewDelegate?
    
    func clearMessageTextField() {
        messageTextView.text = nil
        //        reviewTextView.showPlaceholderLabel()
    }
    
    fileprivate let messageTextView: UITextView = {
        let textView = UITextView()
        textView.placeholder = "Enter message here"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    lazy var addMediaButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddMediaButton)))
        button.isUserInteractionEnabled = true
        return button
    }()
    
    fileprivate let submitButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Submit", for: .normal)
        sb.setTitleColor(.white, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sb.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return sb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        autoresizingMask = .flexibleHeight
        
        backgroundColor = UIColor.mainColor()
        
        addSubview(messageTextView)
        addSubview(submitButton)
        addSubview(addMediaButton)
        
        if #available(iOS 11.0, *) {
            messageTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 40, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        } else {
            // Fallback on earlier versions
        }
        
        submitButton.anchor(top: messageTextView.topAnchor, left: nil, bottom: messageTextView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 60, height: 0)
        
        addMediaButton.anchor(top: messageTextView.topAnchor, left: leftAnchor, bottom: messageTextView.bottomAnchor, right: messageTextView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        setupLineSeparatorView()
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    @objc func handleAddMediaButton(button: UIButton) {
        print("pressed in view")
        delegate?.addMediaSubmit(button: button)
    }
    
    @objc func handleSubmit() {
        guard let messageText = messageTextView.text else { return }
        delegate?.didSubmit(for: messageText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

