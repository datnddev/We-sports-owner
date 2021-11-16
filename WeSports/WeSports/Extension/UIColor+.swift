//
//  UIColor+.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation
import UIKit

extension UIColor {
    static func hex(_ hexStr: String, alpha: CGFloat = 1) -> UIColor {
        let scanner = Scanner(string: hexStr.replacingOccurrences(of: "#", with: ""))
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let redColor = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let greenColor = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let blueColor = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red: redColor, green: greenColor, blue: blueColor, alpha: alpha)
        } else {
            return .white
        }
    }
}

extension UIColor {
    static let hex_211A2C = UIColor.hex("#211A2C")
}
