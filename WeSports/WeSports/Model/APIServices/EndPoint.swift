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
    case getListRenter = "/v1/renter/list"
    case getListOwner = "/v1/owner/list"
    
    case listPitch = "/v1/pitch/list"
    case billByPitch = "/v1/bill/listbypitch"
    case billByRenter = "/v1/bill/listbyrenter"
    case addBill = "/v1/bill/add"
}
