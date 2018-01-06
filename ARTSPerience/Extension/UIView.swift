//
//  UIView.swift
//  CodeBase
//
//  Created by Hafiz on 18/09/2017.
//  Copyright © 2017 github. All rights reserved.
//

import UIKit

extension UIView {
    
    func rounded(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.rounded(radius: radius)
    }
    
    func rounded(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                   shadowOpacity: Float = 0.6,
                   shadowRadius: CGFloat = 8.0, cornerRadius: CGFloat = 4.0) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
