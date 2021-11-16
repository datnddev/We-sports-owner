//
//  UIViewController+.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation
import UIKit

extension UIViewController: ChangeRootViewProtocol {
    func changeRootView(vc rootView: UIViewController) {
        UIView.transition(with: self.view.window!,
                          duration: 0.5,
                          options: .transitionFlipFromLeft,
                          animations: { [weak self] in
                            guard let self = self else { return }
                            self.view.window?.rootViewController = rootView
                          }, completion: nil)
    }
}
