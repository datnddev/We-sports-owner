//
//  LoginResponse.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

struct LoginResponse {
    var id: String?
    var message: String
    var owner: Owner?
}

extension LoginResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case message = "message"
        case owner = "data"
    }
}
