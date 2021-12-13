//
//  ListChatCollectionViewCell.swift
//  WeSports
//
//  Created by datNguyem on 13/12/2021.
//

import UIKit

class ListChatCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!
    
    func configure(renter: Renter) {
        nameLbl.text = renter.name
    }
    
    func configure(owner: Owner) {
        nameLbl.text = owner.name
    }
    
    func configure(listChat: ListChat) {
        nameLbl.text = listChat.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.makeCircle()
    }
}
