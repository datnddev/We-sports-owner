//
//  ReusableView.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation
import UIKit

protocol ReusableView {
    static var identifier: String { get }
    static var nib: UINib { get }
    func loadViewFromNib() -> UIView
}
