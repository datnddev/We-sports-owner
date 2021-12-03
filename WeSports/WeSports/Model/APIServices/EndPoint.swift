//
//  EndPoint.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation

enum EndPoint: String {
    case login = "/v1/renter/login"
    case register = "/v1/renter/register"
    case update = "/v1/renter/update"
    case delete = "/v1/renter/delete"
    case detail = "/v1/renter/detail"
    case sendMail = "/sendmail"
    
    case listPitch = "/v1/pitch/list"
}
