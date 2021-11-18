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

extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnOffKeyBoard()
    }
    
    @objc
    func turnOffKeyBoard() {
        view.endEditing(true)
    }
}

extension UIViewController {
    func showAlertAuth(title: String,
                   message: String,
                   style: UIAlertController.Style = .alert,
                   completion: ((UIAlertController)->Void)?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style)
        completion?(alert)  
        present(alert, animated: true, completion: nil)
    }
}
