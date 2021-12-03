//
//  Price.swift
//  WSManager
//
//  Created by datNguyem on 23/11/2021.
//

import Foundation

struct Price: Codable {
    var start: String
    var end: String
    var cost: Double
}

extension Price {
    static func dummyData() -> [Price] {
        return [
            Price(start: "7:00", end: "10:00", cost: 120000),
            Price(start: "11:00", end: "15:00", cost: 3000000)
        ]
    }
    
    static func validatorTime(start: String, end: String) -> Price? {
        let starts = start.components(separatedBy: ":")
        let ends = end.components(separatedBy: ":")
        print(starts)
        print(ends)
        return nil
    }
}
