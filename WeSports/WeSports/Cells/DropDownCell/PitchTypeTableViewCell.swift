//
//  PitchTypeTableViewCell.swift
//  WeSports
//
//  Created by datNguyem on 30/11/2021.
//

import UIKit
import DropDown

class PitchTypeTableViewCell: DropDownCell, ReusableView {
    @IBOutlet weak var dropImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
