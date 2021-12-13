//
//  Owner.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

struct Renter {
    var id: String?
    var username: String
    var name: String
    var password: String
    var phone: String
    var mail: String
    var accountStatus: Int
    var dateRegister: String
    var fbUrl: String?
}

extension Renter: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case username = "renterUsername"
        case name = "renterName"
        case password = "renterPassword"
        case phone = "renterPhone"
        case mail = "renterEmail"
        case accountStatus = "accountStatus"
        case dateRegister = "renterDateRegister"
        case fbUrl = "renterFbUrl"
    }
}
