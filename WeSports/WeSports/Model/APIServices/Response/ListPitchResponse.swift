//
//  ListPitchResponse.swift
//  WeSports
//
//  Created by datNguyem on 26/11/2021.
//

import Foundation

struct ListPitchResponse: Codable {
    var message: String
    var data: [PitchDetail]
    var status: Int
}
