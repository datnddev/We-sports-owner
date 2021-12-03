//
//  Promo.swift
//  WeSports
//
//  Created by datNguyem on 18/11/2021.
//

import Foundation

struct Promo: Codable {
    var id: String
    var title: String
    var content: String
    var promoCode: String
    var value: Double
    var untilDate: String
    var usageCount: Int
    var color: String
}

extension Promo {
    static func dummyData() -> [Promo] {
        return [
            Promo(id: UUID().uuidString,
                  title: "Giảm tới 50k cho lần đầu",
                  content: "",
                  promoCode: "FF9C00",
                  value: 50000,
                  untilDate: Date().formatDate(format: "dd/mm/YYYY"),
                  usageCount: 3,
                  color: "#FF9C00"),
            Promo(id: UUID().uuidString,
                  title: "Giảm tới 25k cho lần đầu",
                  content: "",
                  promoCode: "HJJG20",
                  value: 50000,
                  untilDate: Date().formatDate(format: "dd/mm/YYYY"),
                  usageCount: 3,
                  color: "#00C323"),
            Promo(id: UUID().uuidString,
                  title: "Giảm tới 10k cho lần đầu",
                  content: "",
                  promoCode: "HJJG20",
                  value: 50000,
                  untilDate: Date().formatDate(format: "dd/mm/YYYY"),
                  usageCount: 3,
                  color: "#1E92F6")
        ]
    }
}
