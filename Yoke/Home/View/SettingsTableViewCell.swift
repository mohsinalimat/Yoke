//
//  SettingsTableViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/11/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    var placeholder: String? {
        didSet {
            guard let item = placeholder else {return}
            dataTextField.placeholder = item
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        constrainViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(dataTextField)
    }
    
    func constrainViews() {
        dataTextField.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, height: 45)
    }
    
    let dataTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.backgroundColor = .yellow
        return textField
    }()

}
