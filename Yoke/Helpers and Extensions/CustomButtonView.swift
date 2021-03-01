//
//  CustomButtonView.swift
//  Yoke
//
//  Created by LAURA JELENICH on 3/1/21.
//  Copyright © 2021 LAURA JELENICH. All rights reserved.
//

import UIKit

extension UIButton {
    
    func alignImageTextVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}

extension UIButton {
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        
        guard let imageView = self.imageView,
            let titleLabel = self.titleLabel else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1;
        let imageSize = imageView.frame.size;
        self.titleEdgeInsets = UIEdgeInsets.init(top: (imageSize.height+gap)*sign, left: -imageSize.width, bottom: 0, right: 0);
        
        let titleSize = titleLabel.bounds.size;
        self.imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height+gap)*sign, left: 0, bottom: 0, right: -titleSize.width);
    }
}

extension NSTextAttachment {
    func setImageHeight(height: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.width / image.size.height
        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}
