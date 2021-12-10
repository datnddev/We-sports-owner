//
//  TimePriceCollectionViewCell.swift
//  WeSports
//
//  Created by datNguyem on 09/12/2021.
//

import UIKit

class TimePriceCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    var isAvailable: Bool = true {
        didSet {
            isUserInteractionEnabled = isAvailable
            timeLbl.textColor = isAvailable ? .hex_211A2C : .white
            priceLbl.textColor = isAvailable ? .hex_211A2C : .white
        }
    }
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 1 : 0
            layer.borderColor = isSelected ? UIColor.hex_211A2C.cgColor :
                UIColor.clear.cgColor
        }
    }
    
    func configure(timePerRent: TimePerRent) {
        timeLbl.text = timePerRent.time.components(separatedBy: " ")[1]
        priceLbl.text = "\(timePerRent.price.roundedWithAbbreviations)"
        isAvailable = timePerRent.isAvailable
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRadius(radius: 8)
        clipsToBounds = true
        backgroundColor = .systemGray4
    }
}
