//
//  UIImageView.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation
import UIKit

extension UIView {
    func makeCircle() {
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2
    }
    
    func makeRadius(radius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = radius
    }
    
    func makeRadius(radius: CGFloat, mask: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = mask
    }
}
