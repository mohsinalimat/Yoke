//
//  EmailPasswordChangeViewController.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/14/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class EmailPasswordChangeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Helper Functions
    func setupViews() {
        
    }
 
    //MARK: - Views
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.isSecureTextEntry = true
        text.textColor = UIColor.black
        text.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
//        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
    
    let emailTextField: UITextField = {
        let text = UITextField()
        text.textColor = UIColor.black
        text.attributedPlaceholder = NSAttributedString(string: "New Email", attributes:[NSAttributedString.Key.foregroundColor: UIColor.gray])
        text.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        text.layer.cornerRadius = 5
        text.font = UIFont.systemFont(ofSize: 14)
//        text.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return text
    }()
}
