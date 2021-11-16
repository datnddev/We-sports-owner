//
//  APIError.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

enum APIError: Error {
    case decodeError
    case encodeError
    case urlError
    case responseError
}
