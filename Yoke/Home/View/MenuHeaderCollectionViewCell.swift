//
//  MenuHeaderCollectionViewCell.swift
//  Yoke
//
//  Created by LAURA JELENICH on 1/12/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

protocol MenuHeaderDelegate: class {
    func addMenu(_ sender: MenuHeaderCollectionViewCell)
//    func addMenu(user: User)
}

class MenuHeaderCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var delegate: MenuHeaderDelegate?
    
    var user: User? {
        didSet {
            
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
    
    //MARK: - Helper Functions
    func setupViews(){
        addSubview(menuLabel)
        addSubview(addMenuButton)
    }
    
    func setupConstraints() {
        menuLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, height: 45)
        addMenuButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 75, height: 45)
    }
    
    @objc func handleAddMenu(_ sender: Any) {
        print("tapped in cell")
        delegate?.addMenu(self)
    }

    //MARK: - Views
    let menuLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.orangeColor()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var addMenuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Add Menu", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.setTitleColor(UIColor.orangeColor(), for: .normal)
        button.addTarget(self, action: #selector(handleAddMenu), for: .touchUpInside)
        return button
    }()
}
