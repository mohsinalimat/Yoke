//
//  CusineCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/19/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class CusineCollectionViewCell: UICollectionViewCell {
    var cusine: Cusine? {
        didSet {
            guard let cusine = cusine?.type else { return }
            label.text = cusine
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(label)
    }
    
    func setupConstraints() {
        label.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "bla"
        return label
    }()
}
