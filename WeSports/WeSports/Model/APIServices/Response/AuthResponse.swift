//
//  LoginResponse.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

struct AuthResponse {
    var id: String?
    var message: String
    var status: Int?
    var renter: Renter?
}

extension AuthResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case message = "message"
        case status = "status"
        case renter = "data"
    }
}

enum AuthStatus: Int {
    case succes = 0
    case fail = 1
    case notVerify = 2    
}
