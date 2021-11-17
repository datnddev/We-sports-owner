//
//  ReusableView+.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation
import UIKit

extension ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func loadViewFromNib() -> UIView {
        return Self.nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
