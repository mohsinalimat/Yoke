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
            for c in cusine {
              label.text = "\(c)"
            }
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
        label.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, height: 30)
    }
    
    var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.orangeColor()
        label.layer.cornerRadius = 2
        label.textAlignment = .center
        return label
    }()
}
