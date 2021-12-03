//
//  PitchTableViewCell.swift
//  WeSports
//
//  Created by datNguyem on 26/11/2021.
//

import UIKit

class PitchTableViewCell: UITableViewCell, ReusableView {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pitchImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var remainingLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    func configure(pitchDetail: PitchDetail) {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupView() {
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowOpacity = 0.05
        containerView.layer.shadowRadius = 20
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds,
                                                      cornerRadius: 20).cgPath
    }
}
