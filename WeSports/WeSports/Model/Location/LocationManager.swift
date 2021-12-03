//
//  LocationManager.swift
//  WeSports
//
//  Created by datNguyem on 02/12/2021.
//

import Foundation
import UIKit
import CoreLocation

typealias LocationCompletion = (CLLocation) -> ()

final class LocationManager: NSObject {
    
    //MARK: - Singleton
    static let shared = LocationManager()
    
    //MARK: -Properties
    fileprivate let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentLocationCompletion: LocationCompletion?
    private var locationCompletion: LocationCompletion?
    private var isUpdatingLocation = false
    
    private override init() {
        super.init()
        configLocation()
    }
    
    private func configLocation() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10
    }
    
    func startUpdatingLocation(completion: @escaping LocationCompletion) {
        locationCompletion = completion
        isUpdatingLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        isUpdatingLocation = false
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocation() -> CLLocation? {
        let status = getAuthorizationStatus()
        if status == .denied || status == .notDetermined || status == .restricted
            || !CLLocationManager.locationServicesEnabled() {
            showAlertGotoSetting()
            return nil
        }
        return currentLocation
    }
    
    func showAlertGotoSetting() {
        let keyWindow = UIApplication.keyWindow
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let message = "Ứng dụng không có quyền sử dụng vị trí.\nVui lòng cấp quyền để có thể sử dụng ứng dụng"
            let alertController = UIAlertController(title: "",
                                                    message: message, preferredStyle: .alert)
            let settingAction = UIAlertAction(title: "Đi tới cài đặt", style: .default) { alert in
                guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingUrl) {
                    UIApplication.shared.open(settingUrl) { success in
                        print("Setting open: \(success)")
                    }
                }
            }
            alertController.addAction(settingAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        if #available(iOS 14.0, *) {
            return locationManager.authorizationStatus
        } else {
            return CLLocationManager.authorizationStatus()
        }
    }
    
    func request() {
        let status = getAuthorizationStatus()
        
        if status == .denied
            || status == .restricted
            || !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.requestLocation()
    }
    
    func locationFromAddress(address: String, completion: ((CLLocation?) -> Void)?) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { placemarks, error in
            guard let location = placemarks?.first?.location else {
                completion?(nil)
                return
            }
            completion?(location)
        }
    }
    
    func geocode(latitude: Double, longitude: Double,
                 completion: @escaping ([CLPlacemark]?, Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(
            CLLocation(latitude: latitude, longitude: longitude)
            , preferredLocale: Locale(identifier: "vi_VN")) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    func geocode(location: CLLocation, completion: @escaping ([CLPlacemark]?, Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(location,
                                            preferredLocale: Locale(identifier: "vi_VN")) { placemark, error in
            guard let placemark = placemark, error == nil else {
                completion(nil, error)
                return
            }
            completion(placemark, nil)
        }
    }
    
    func distanceTo(toLocation: CLLocation) -> CLLocationDistance? {
        guard let location = currentLocation else {
            print("Can not get current location")
            return nil
        }
        return location.distance(from: toLocation)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            manager.requestLocation()
            
        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()
            
        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")
            
        case .restricted:
            print("parental control setting disallow location data")
            
        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
            
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastestLocation = locations.last(where: {$0.horizontalAccuracy >= 0}) {
            currentLocation = lastestLocation
            
            if let currentCompletion = currentLocationCompletion {
                currentCompletion(lastestLocation)
            }
            
            if isUpdatingLocation, let updating = locationCompletion {
                updating(lastestLocation)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error in LocationManager: \(String(describing: error))")
    }
}


