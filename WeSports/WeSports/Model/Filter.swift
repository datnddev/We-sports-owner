//
//  Filter.swift
//  WeSports
//
//  Created by datNguyem on 05/12/2021.
//

import Foundation

struct Filter: Codable {
    var addressCity: City?
    var addressDistrict: District?
    var minPrice: Double?
    var maxPrice: Double?
    var distance: Double = 1
}
