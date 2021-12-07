//
//  PitchDetail.swift
//  WeSports
//
//  Created by datNguyem on 26/11/2021.
//

import Foundation

struct PitchDetail {
    var id: String?
    var pitchName: String
    var pitchType: PitchType
    var pitchSize: Int
    var pitchAddress: PitchAddress
    var pitchOpen: String
    var pitchClose: String
    var timePerRent: Int
    var minPrice: Double
    var maxPrice: Double
    var prices: [Price]
    var services: [String]?
    var images: [String]?
    var pitchOwner: Owner?
    var pitchStatus: Int
}

extension PitchDetail: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pitchName = "pitchName"
        case pitchType = "pitchType"
        case pitchSize = "pitchSize"
        case pitchAddress = "pitchAddress"
        case pitchOpen = "pitchOpen"
        case pitchClose = "pitchClose"
        case timePerRent = "timePerRent"
        case minPrice = "minPrice"
        case maxPrice = "maxPrice"
        case prices = "pitchPrice"
        case services = "service"
        case images = "pitchImage"
        case pitchOwner = "pitchOwner"
        case pitchStatus = "pitchStatus"
    }
}
