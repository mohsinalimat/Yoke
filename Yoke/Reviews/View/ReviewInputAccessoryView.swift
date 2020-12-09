//
//  ReviewInputAccessoryView.swift
//  FooD
//
//  Created by LAURA JELENICH on 3/29/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit

protocol ReviewInputAccessoryViewDelegate {
    func didSubmit(for review: String)
}

class ReviewInputAccessoryView: UIView {
    
    var delegate: ReviewInputAccessoryViewDelegate?
    
    func clearReviewTextField() {
        reviewTextView.text = nil
//        reviewTextView.showPlaceholderLabel()
    }
    
    fileprivate let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.placeholder = "Enter Review"
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
        addSubview(reviewTextView)
        
        if #available(iOS 11.0, *) {
            reviewTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 50, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        } else {
            // Fallback on earlier versions
        }
        
        submitButton.anchor(top: reviewTextView.topAnchor, left: nil, bottom: reviewTextView.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
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
        guard let reviewText = reviewTextView.text else { return }
        delegate?.didSubmit(for: reviewText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
