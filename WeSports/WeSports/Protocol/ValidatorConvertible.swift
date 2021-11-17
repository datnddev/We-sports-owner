//
//  ValidatorConvertible.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

protocol ValidatorConvertible {
    func validated(_ value: String, value compare: String?) throws -> String
}
