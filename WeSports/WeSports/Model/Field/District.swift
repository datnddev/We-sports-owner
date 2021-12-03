//
//  District.swift
//  WSManager
//
//  Created by datNguyem on 22/11/2021.
//

import Foundation

struct District {
    var name: String
    var slug: String
    var nameWithType: String
    var code: String
    var parentCode: String
}

extension District: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case slug
        case nameWithType = "name_with_type"
        case code
        case parentCode = "parent_code"
    }
}
