//
//  String+.swift
//  WeSports
//
//  Created by datNguyem on 09/12/2021.
//

import Foundation

extension String {
    func date(format: String, localeStr: String?) -> Date {
        let inFormatter = DateFormatter()
        inFormatter.dateFormat = format

        if let localeStr = localeStr {
            let locale = Locale(identifier: localeStr)
            inFormatter.locale = locale
        }

        return inFormatter.date(from: self)!
    }
}
