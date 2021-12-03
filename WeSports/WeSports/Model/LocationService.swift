//
//  LocationManager.swift
//  WeSports
//
//  Created by datNguyem on 29/11/2021.
//

import Foundation
import CoreLocation

//final class LocationService: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationService()
//    var locationManager = CLLocationManager()
//    var currentLocation: CLLocation?
//    var locationInfoCallBack: ((CLLocation? ,CLPlacemark?) -> Void)!
//    
//    private override init() {        
//        self.locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        super.init()
//        locationManager.delegate = self
//    }
//    
//    func start(locationInfoCallBack: @escaping ((CLLocation?, CLPlacemark?) -> Void)) {
//        self.locationInfoCallBack = locationInfoCallBack
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//    
//    func stop() {
//        locationManager.stopUpdatingLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        switch status {
//        case .authorizedAlways:
//            print("user allow app to get location data when app is active or in background")
//        case .authorizedWhenInUse:
//            print("user allow app to get location data only when app is active")
//        case .denied:
//            print("user tap 'disallow' on the permission dialog, cant get location data")
//        case .restricted:
//            print("parental control setting disallow location data")
//        case .notDetermined:
//            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")
//        default:
//            print("default")
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {
//            locationInfoCallBack(nil, nil)
//            return
//        }
//        geocode(location: location) { placemarks, error in
//            guard let placemarks = placemarks, error == nil, let place = placemarks.first else {
//                return
//            }
//            self.locationInfoCallBack(location, place)
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
//    }
//    
//    func distanceTo(address: String, completion: @escaping ((CLLocationDistance) -> Void)) {
//        locationFromAddress(address: address) { [weak self] location in
//            guard let self = self,
//                  let currentLocation = self.locationManager.location else { return }
//            completion(currentLocation.distance(from: location))
//        }
//    }
//    
//    func distanceTo(from: CLLocation, completion: @escaping ((CLLocationDistance) -> Void)) {
//        guard let location = locationManager.location else { return }
//        geocode(location: location) { placemarks, error in
//            guard let placemarks = placemarks, error == nil, let place = placemarks.first else {
//                return
//            }
//        }
//        completion(location.distance(from: from))
//    }
//    
//    func locationFromAddress(address: String, completion: ((CLLocation) -> Void)?) {
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(address) { placemarks, error in
//            guard let location = placemarks?.first?.location else {
//                return
//            }
//            completion?(location)
//        }
//    }
//    
//    func geocode(latitude: Double, longitude: Double,
//                 completion: @escaping ([CLPlacemark]?, Error?) -> Void)  {
//        CLGeocoder().reverseGeocodeLocation(
//            CLLocation(latitude: latitude, longitude: longitude)
//            , preferredLocale: Locale(identifier: "vi_VN")) { placemark, error in
//            guard let placemark = placemark, error == nil else {
//                completion(nil, error)
//                return
//            }
//            completion(placemark, nil)
//        }
//    }
//    
//    func geocode(location: CLLocation, completion: @escaping ([CLPlacemark]?, Error?) -> Void)  {
//        CLGeocoder().reverseGeocodeLocation(location,
//                                            preferredLocale: Locale(identifier: "vi_VN")) { placemark, error in
//            guard let placemark = placemark, error == nil else {
//                completion(nil, error)
//                return
//            }
//            completion(placemark, nil)
//        }
//    }
//}
