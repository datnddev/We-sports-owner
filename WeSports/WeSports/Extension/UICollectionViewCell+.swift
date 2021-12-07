//
//  UICollectionViewCell+.swift
//  WeSports
//
//  Created by datNguyem on 05/12/2021.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
