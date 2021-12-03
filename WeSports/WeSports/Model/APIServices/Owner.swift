//
//  Owner.swift
//  WeSports
//
//  Created by datNguyem on 26/11/2021.
//

import Foundation

struct Owner {
    var id: String?
    var name: String
    var phone: String
    var mail: String
}

extension Owner: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "ownerName"
        case phone = "ownerPhone"
        case mail = "ownerEmail"
    }
}
