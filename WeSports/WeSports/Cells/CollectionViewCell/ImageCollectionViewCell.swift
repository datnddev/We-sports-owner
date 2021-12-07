//
//  ImageCollectionViewCell.swift
//  WeSports
//
//  Created by datNguyem on 05/12/2021.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var fieldImageVIew: UIImageView!
    
    func configure(imageUrl: String) {
        ImageServices.shared.load(path: imageUrl, for: fieldImageVIew)
    }
    
    func setDefaultImage() {
        fieldImageVIew.image = UIImage(named: "fieldDefault")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fieldImageVIew.contentMode = .scaleAspectFill
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        ImageServices.shared.cancel(for: fieldImageVIew)
        fieldImageVIew.image = nil
    }
}
