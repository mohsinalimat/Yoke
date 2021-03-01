//
//  CustomColorView.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func yellowColor() -> UIColor? {
       return UIColor(named: "PrimaryYellow")
    }
    
    static func orangeColor() -> UIColor? {
       return UIColor(named: "PrimaryOrange")
    }
    
    static func LightGrayBg() -> UIColor? {
        return UIColor(named: "LightGrayBg")
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
