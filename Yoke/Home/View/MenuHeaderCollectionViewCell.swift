//
//  MenuHeaderCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/12/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

class MenuHeaderCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(menuLabel)
    }
    
    func setupConstraints() {
        menuLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0)
    }
    
    let menuLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.orangeColor()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
}
