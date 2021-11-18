//
//  Owner.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

struct Owner {
    var id: String?
    var username: String
    var name: String
    var password: String
    var phone: String
    var mail: String
    var accountStatus: Int
    var dateRegister: String
}

extension Owner: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username = "ownerUsername"
        case name = "ownerName"
        case password = "ownerPassword"
        case phone = "ownerPhone"
        case mail = "ownerEmail"
        case accountStatus = "accountStatus"
        case dateRegister = "ownerDateRegister"
    }
}
