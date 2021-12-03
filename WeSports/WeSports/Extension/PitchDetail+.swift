//
//  PitchDetail+.swift
//  WeSports
//
//  Created by datNguyem on 30/11/2021.
//

import Foundation

extension PitchDetail {
    static func dummyData() -> [PitchDetail] {
        return [
            PitchDetail(
                id: "0001",
                pitchName: "Sân 01",
                pitchType: PitchType(id: "0", type: "Bóng đá", icon: "soccer"),
                pitchSize: 5,
                pitchAdress: PitchAddress(
                    city: City(
                        name: "001",
                        slug: "Đà Nẵng",
                        type: "da-nang",
                        nameWithType: "thanh-pho",
                        code: "Thành phố Đà Nẵng"),
                    district: District(
                        name: "120",
                        slug: "Thanh Khê",
                        nameWithType: "thanh-khe",
                        code: "Quận Thanh Khê",
                        parentCode: "001"),
                    street: "37A Điện Biên Phủ, Thạc Gián",
                    location: nil),
                pitchOpen: "7:00",
                pitchClose: "21:00",
                timePerRent: 60,
                minPrice: 100000, maxPrice: 100000,
                prices: [
                    Price(start: "7:00", end: "21:00", cost: 100000)
                ],
                services: [
                    "Giữ xe miễn phí",
                    "Nước uống mất phí",
                    "Tủ đồ miễn phí"
                ],
                images: [
                    "https://firebasestorage.googleapis.com/v0/b/wesports-60be7.appspot.com/o/DF94DDEC-1E53-41FB-B4BC-A5511C820785?alt=media&token=c6e52839-23df-4e53-a713-3fe97bb689bc"
                ],
                pitchOwner: nil,
                pitchStatus: 1),
            PitchDetail(
                id: "0002",
                pitchName: "Sân 02",
                pitchType: PitchType(id: "0", type: "Bóng đá", icon: "soccer"),
                pitchSize: 5,
                pitchAdress: PitchAddress(
                    city: City(
                        name: "001",
                        slug: "Đà Nẵng",
                        type: "da-nang",
                        nameWithType: "thanh-pho",
                        code: "Thành phố Đà Nẵng"),
                    district: District(
                        name: "120",
                        slug: "Thanh Khê",
                        nameWithType: "thanh-khe",
                        code: "Quận Thanh Khê",
                        parentCode: "001"),
                    street: "44 Dũng Sĩ Thanh Khê, Thanh Khê Tây",
                    location: nil),
                pitchOpen: "7:00",
                pitchClose: "21:00",
                timePerRent: 60,
                minPrice: 100000, maxPrice: 200000,
                prices: [
                    Price(start: "7:00", end: "14:59", cost: 100000),
                    Price(start: "15:00", end: "21:00", cost: 200000)
                ],
                services: [
                    "Giữ xe miễn phí",
                    "Nước uống mất phí",
                    "Tủ đồ miễn phí"
                ],
                images: [
                    "https://firebasestorage.googleapis.com/v0/b/wesports-60be7.appspot.com/o/DF94DDEC-1E53-41FB-B4BC-A5511C820785?alt=media&token=c6e52839-23df-4e53-a713-3fe97bb689bc"
                ],
                pitchOwner: nil,
                pitchStatus: 1)
        ]
    }
}
