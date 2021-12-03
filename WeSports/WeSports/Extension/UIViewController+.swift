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

fileprivate let roatingCirclesView = RoatingCircleView()

extension UIViewController {
    func addLoadingScreen() {
        UIApplication.shared.windows.first{$0.isKeyWindow}?
            .addSubview(roatingCirclesView)
        roatingCirclesView.frame = UIScreen.main.bounds
        roatingCirclesView.animate(roatingCirclesView.circle1, counter: 1)
        roatingCirclesView.animate(roatingCirclesView.circle2, counter: 3)
    }
    
    func removeLoadingScreen() {
        roatingCirclesView.removeFromSuperview()
    }
}

extension UIViewController {
    var citys: [City] {
        guard let path = Bundle.main.path(forResource: "city",
                                          ofType: "json") else { return [] }
        do {
            if let data = DataCacheManager.shared.dataCache.value(for: NSString(string: "city")) {
                return try JSONDecoder().decode([City].self, from: data)
            }
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            DataCacheManager.shared.dataCache.insert(data, for: NSString(string: "city"))
            return try JSONDecoder().decode([City].self, from: data)
        } catch {
            print(String(describing: error))
            return []
        }
    }
    
    func currentCity(completion: @escaping ((City) -> Void)) {
        guard let cllocation = LocationManager.shared.getCurrentLocation() else {
            completion(citys[0])
            return
        }
        LocationManager.shared.geocode(location: cllocation) { placemark, _ in
            guard let placemark = placemark?.first,
                  let city = self.citys.filter({$0.name == placemark.locality}).first else {
                completion(self.citys[0])
                return
            }
            completion(city)
        }
    }
}
