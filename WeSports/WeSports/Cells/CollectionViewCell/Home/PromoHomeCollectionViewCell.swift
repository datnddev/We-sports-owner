//
//  PromoHomeCollectionViewCell.swift
//  WeSports
//
//  Created by datNguyem on 18/11/2021.
//

import UIKit

class PromoHomeCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(promo: Promo) {
        titleLabel.text = promo.title
        backgroundColor = UIColor.hex(promo.color)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 20
        clipsToBounds = true
    }
}
