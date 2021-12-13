//
//  ListRenterResponse.swift
//  WeSports
//
//  Created by datNguyem on 13/12/2021.
//

import Foundation

struct ListRenterResponse: Codable {
    var message: String
    var status: Int
    var data: [Renter]?
}
