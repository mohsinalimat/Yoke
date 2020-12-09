//
//  CommentInputAccessoryView.swift
//  FooD
//
//  Created by LAURA JELENICH on 4/17/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class CommentInputAccessoryView: UIView {
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentTextField() {
        commentTextView.text = nil
        //        reviewTextView.showPlaceholderLabel()
    }
    
    func commentFieldDone() {
        commentTextView.endEditing(true)
    }
    
    fileprivate let commentTextView: UITextView = {
        let textView = UITextView()
        textView.placeholder = "Enter Comment"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor.black
        textView.backgroundColor = .white
        textView.layer.cornerRadius = 5
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
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
        
        addSubview(submitButton)
        addSubview(commentTextView)
        
        if #available(iOS 11.0, *) {
            commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        } else {
            // Fallback on earlier versions
        }
        
        submitButton.anchor(top: commentTextView.topAnchor, left: nil, bottom: commentTextView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
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
    
    @objc func handleSubmit() {
        guard let commentText = commentTextView.text else { return }
        delegate?.didSubmit(for: commentText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
