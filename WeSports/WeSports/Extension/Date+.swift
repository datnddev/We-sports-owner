//
//  Date+.swift
//  WeSports
//
//  Created by datNguyem on 18/11/2021.
//

import Foundation

extension Date {
    func formatDate(format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format
        return dateFormat.string(from: self)
    }
}
