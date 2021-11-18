//
//  SceneDelegate.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        
        if !UserDefaults.standard.bool(forKey: Constant.firstLoginKey) {
            window?.rootViewController = RootViewController.splashRootView()
        } else if UserDefaults.standard.string(forKey: Constant.loggedKey) == nil {
            window?.rootViewController = RootViewController.loginRootView()
        } else {
            window?.rootViewController = RootViewController.mainRootView()
        }
    }
}
