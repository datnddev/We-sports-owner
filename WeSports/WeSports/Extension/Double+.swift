//
//  Double+.swift
//  WeSports
//
//  Created by datNguyem on 30/11/2021.
//

import Foundation

extension Double {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(String(format: "%.0f", million))M"
        }
        else if thousand >= 100 {
            return "\(String(format: "%.0f", thousand))K"
        }
        else {
            return "\(String(format: "%.0f", number/1000)).000đ"
        }
    }
}
