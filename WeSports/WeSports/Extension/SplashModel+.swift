//
//  SplashModel+.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import Foundation
import UIKit

extension SplashModel {
    static var dataSplash: [SplashModel] {
        return [
            SplashModel(image: UIImage(named: "welcome1"),
                        title: "Chào mừng bạn đến với WeSports",
                        content: "Ứng dụng đặt sân hàng đầu Việt Nam"),
            SplashModel(image: UIImage(named: "welcome2"),
                        title: "Tìm kiếm nhanh gọn, đặt sân thần tốc",
                        content: "Tìm kiếm và đặt sân theo cách trực tuyến, giao diện trực quan"),
            SplashModel(image: UIImage(named: "welcome3"),
                        title: "Giao hữu dễ dàng, tình bạn đi lên",
                        content: "Hãy cùng chúng tôi tham gia những trận đấu kịch tính")
        ]
    }
}
