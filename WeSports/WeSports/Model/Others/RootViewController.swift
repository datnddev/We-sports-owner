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
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            selectedImage: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.navigationBar.isHidden = true
        
        let searchVC = SearchViewController()
        searchVC.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass.circle.fill"),
            selectedImage: nil)
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.navigationBar.isHidden = true
        
        let tabBarVc = UITabBarController()
        UITabBar.appearance().tintColor = .hex_211A2C
        tabBarVc.viewControllers = [homeNav, searchNav]
        return tabBarVc
    }
}
