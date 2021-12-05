//
//  LocationManager+.swift
//  WeSports
//
//  Created by datNguyem on 04/12/2021.
//

import Foundation
import CoreLocation

extension LocationManager {
    static var citys: [City] {
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
    
    static func currentCity(completion: @escaping ((City) -> Void)) {
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
