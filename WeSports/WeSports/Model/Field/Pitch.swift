//
//  PitchDetail.swift
//  WSManager
//
//  Created by datNguyem on 25/11/2021.
//

import Foundation

struct Pitch {
    var id: String?
    var pitchName: String
    var pitchType: PitchType
    var pitchSize: Int
    var pitchAdress: PitchAddress
    var pitchOpen: String
    var pitchClose: String
    var timePerRent: Int
    var minPrice: Double
    var maxPrice: Double
    var prices: [Price]
    var services: [String]
    var images: [String]
    var pitchOwner: String
}

extension Pitch: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case pitchName = "pitchName"
        case pitchType = "pitchType"
        case pitchSize = "pitchSize"
        case pitchAdress = "pitchAddress"
        case pitchOpen = "pitchOpen"
        case pitchClose = "pitchClose"
        case timePerRent = "timePerRent"
        case minPrice = "minPrice"
        case maxPrice = "maxPrice"
        case prices = "pitchPrice"
        case services = "service"
        case images = "pitchImage"
        case pitchOwner = "pitchOwner"
    }
}

//{
//    "message": "Get all pitch success",
//    "data": [
//        {
//            "_id": "619f31e6ea0729c7437ef9c2",
//            "pitchName": "tên sân1",
//            "pitchType": {
//                "id": "String",
//                "type": "Bóng đá",
//                "icon": "tên icon"
//            },
//            "pitchSize": 10,
//            "pitchAddress": {
//                "_id": "619f31e5ea0729c7437ef9c0",
//                "addressCity": {
//                    "code": "01",
//                    "name": "Ha Noi"
//                },
//                "addressDistrict": {
//                    "code": "12",
//                    "name_with_type": "Quan Long Bien"
//                },
//                "addressStreet": "167 Hai Thuong Lan Ong",
//                "__v": 0
//            },
//            "pitchOpen": "7:00",
//            "pitchClose": "21:30",
//            "timePerRent": 60,
//            "minPrice": 80000,
//            "maxPrice": 100000,
//            "pitchPrice": [
//                {
//                    "start": "7:00",
//                    "end": "10:59",
//                    "cost": 100000
//                },
//                {
//                    "start": "11:00",
//                    "end": "13:59",
//                    "cost": 80000
//                }
//            ],
//            "service": null,
//            "pitchImage": [],
//            "pitchOwner": {
//                "_id": "6193f9e41fac0f491258b813",
//                "ownerUsername": "dato1",
//                "ownerName": "dat n",
//                "ownerPassword": "t12345678",
//                "ownerPhone": "0908812312",
//                "ownerEmail": "test2@gmail.com",
//                "accountStatus": 1,
//                "ownerDateRegister": "11/16/2021",
//                "__v": 0
//            },
//            "pitchStatus": 1,
//            "__v": 0
//        },
