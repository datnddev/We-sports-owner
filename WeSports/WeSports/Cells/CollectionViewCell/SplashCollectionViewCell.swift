//
//  SplashCollectionViewCell.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import UIKit

class SplashCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var splashImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .hex_211A2C
//        splashImageView.contentMode = .as
    }
    
    func configure(splash: SplashModel) {
        splashImageView.image = splash.image
        titleLabel.text = splash.title
        contentLabel.text = splash.content
    }
}
