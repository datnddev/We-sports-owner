//
//  RootViewController.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation
import UIKit

enum RootViewController {
    static func splashRootView() -> UIViewController {
        return SplashViewController()
    }
    
    static func loginRootView() -> UIViewController {
        let loginVC = LoginViewController()
        let nav = UINavigationController(rootViewController: loginVC)
        return nav
    }
    
    static func mainRootView() -> UIViewController {
        return MainViewController()
    }
}
