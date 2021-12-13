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
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: .main)
        homeVC.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            selectedImage: nil)
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.navigationBar.isHidden = true
        
        let searchVC = SearchViewController(nibName: "SearchViewController", bundle: .main)
        searchVC.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass.circle.fill"),
            selectedImage: nil)
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.navigationBar.isHidden = true
        
        let listChatVC = ListChatViewController(nibName: "ListChatViewController", bundle: .main)
        listChatVC.tabBarItem = UITabBarItem(
            title: "Chat",
            image: UIImage(systemName: "message.fill"),
            selectedImage: nil)
        let listChatNav = UINavigationController(rootViewController: listChatVC)                        
        
        let tabBarVc = UITabBarController()
        UITabBar.appearance().tintColor = .hex_211A2C
        tabBarVc.viewControllers = [homeNav, searchNav, listChatNav]
        return tabBarVc
    }
}
