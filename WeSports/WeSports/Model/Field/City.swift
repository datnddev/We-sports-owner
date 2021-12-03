//
//  City.swift
//  WSManager
//
//  Created by datNguyem on 22/11/2021.
//

import Foundation

struct City {
    var name: String
    var slug: String
    var type: String
    var nameWithType: String
    var code: String
}

extension City: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case slug
        case type
        case nameWithType = "name_with_type"
        case code
    }
}
