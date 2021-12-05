//
//  PitchAddress.swift
//  WSManager
//
//  Created by datNguyem on 25/11/2021.
//

import Foundation

struct PitchAddress {
    var city: City?
    var district: District?
    var street: String?
    var location: Location?
}

extension PitchAddress: Codable {
    enum CodingKeys: String, CodingKey {
        case city = "addressCity"
        case district = "addressDistrict"
        case street = "addressStreet"
        case location = "addressLocation"
    }
}
