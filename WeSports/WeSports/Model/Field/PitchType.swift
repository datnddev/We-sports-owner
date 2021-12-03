//
//  FieldType.swift
//  WSManager
//
//  Created by datNguyem on 22/11/2021.
//

import Foundation

struct PitchType: Codable {
    var id: String
    var type: String
    var icon: String?
}

extension PitchType {
    static func dummyData() -> [PitchType] {
        return [
            PitchType(id: "0", type: "Bóng đá", icon: "soccer"),
            PitchType(id: "1", type: "Bóng chuyền", icon: "volleyball"),
            PitchType(id: "2", type: "Bóng rổ", icon: "basketball"),
            PitchType(id: "3", type: "Bóng tennis", icon: "tennis"),
            PitchType(id: "4", type: "Tất cả", icon: "stadium")
        ]
    }
}
