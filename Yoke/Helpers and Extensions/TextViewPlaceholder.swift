//
//  TextViewPlaceholder.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import Foundation
import UIKit

private var kAssociationKeyMaxLength: Int = 0

extension UITextView: UITextViewDelegate {
    
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLbl = self.viewWithTag(50) as? UILabel {
                placeholderText = placeholderLbl.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
                placeholderLbl.text = newValue
                placeholderLbl.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLbl = self.viewWithTag(50) as? UILabel {
            placeholderLbl.isHidden = self.text.count > 0
        }
    }
    
    private func resizePlaceholder() {
        if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
            let x = self.textContainer.lineFragmentPadding
            let y = self.textContainerInset.top - 2
            let width = self.frame.width - (x * -100)
            let height = placeholderLbl.frame.height
            
            placeholderLbl.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLbl = UILabel()
        
        placeholderLbl.text = placeholderText
        placeholderLbl.sizeToFit()
        
        placeholderLbl.font = self.font
        placeholderLbl.textColor = UIColor.darkGray
        placeholderLbl.tag = 50
        
        placeholderLbl.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLbl)
        self.resizePlaceholder()
        self.delegate = self
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
