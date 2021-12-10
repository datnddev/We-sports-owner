//
//  Bill.swift
//  WeSports
//
//  Created by datNguyem on 08/12/2021.
//

import Foundation

struct Bill {
    var id: String?
    var pitchId: String
    var renterId: String
    var timeRent: [String]
    var total: Double
    var status: Int
    var date: String
}

extension Bill: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pitchId = "pitch"
        case renterId = "renter"
        case timeRent
        case total
        case status
        case date
    }
}
