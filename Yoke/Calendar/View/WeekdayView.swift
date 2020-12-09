//
//  WeekdayView.swift
//  FooD
//
//  Created by LAURA JELENICH on 2/26/19.
//  Copyright © 2019 LAURA JELENICH. All rights reserved.
//

import UIKit

class WeekdaysView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(myStackView)
        myStackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let daysArr = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        for i in 0..<7 {
            let label = UILabel()
            label.text = daysArr[i]
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textColor = UIColor.darkGray
            myStackView.addArrangedSubview(label)
        }
    }
    
    let myStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
