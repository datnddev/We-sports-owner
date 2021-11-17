//
//  UITextField+.swift
//  WeSports
//
//  Created by datNguyem on 17/11/2021.
//

import Foundation
import UIKit

extension UITextField {
    func validateText(type: ValidatorType, for compare: String?) throws -> String {
        return try ValidatorFactory.validatorFor(type: type).validated(self.text!, value: compare)
    }
}
