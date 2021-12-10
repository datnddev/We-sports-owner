//
//  TimePerRentCollectionViewCell.swift
//  WeSports
//
//  Created by datNguyem on 10/12/2021.
//

import UIKit

final class TimePerRentCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var startTimeLbl: UILabel!
    @IBOutlet private weak var endTimeLbl: UILabel!
    @IBOutlet private weak var priceLbl: UILabel!
    
    func configure(timePerRent: TimePerRent, time: Int) {
        let date = timePerRent.time.date(format: "dd/MM/yyyy HH:mm", localeStr: "vi_VN")
        startTimeLbl.text = "\(date.formatDate(format: "HH:mm"))"
        endTimeLbl.text =
            "Đến \(date.addingTimeInterval(TimeInterval((time-1)*60)).formatDate(format: "HH:mm"))"
        priceLbl.text = "\(timePerRent.price.convertToVND()!)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addBottomBorderWithColor(color: .hex_211A2C, width: 1)
    }
}
