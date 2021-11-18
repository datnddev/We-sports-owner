//
//  Constants.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

struct GetUrl {
    static func baseUrl(endPoint: EndPoint) -> String {
        return "https://we-sports-sv.herokuapp.com\(endPoint.rawValue)"
    }
}

enum Constant {
    static let firstLoginKey = "FIRSTLOGIN"
    static let loggedKey = "LOGGED"
}
