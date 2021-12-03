//
//  NearByFieldCollectionViewCell.swift
//  WeSports
//
//  Created by datNguyem on 19/11/2021.
//

import UIKit
import CoreLocation

class FieldCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var fieldImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet private weak var slotLabel: UILabel!
    @IBOutlet private weak var bottomUIView: UIView!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    func configure(pitchDetail: PitchDetail) {
        if let imageUrl = pitchDetail.images?.first {
            ImageServices.shared.load(path: imageUrl, for: fieldImageView)
        } else {
            fieldImageView.image = UIImage(named: "fieldDefault")
        }
        nameLabel.text = pitchDetail.pitchName
        addressLabel.text = "\(pitchDetail.pitchAdress.district.name), \(pitchDetail.pitchAdress.city.name)"
        priceLabel.text = "\(pitchDetail.minPrice.roundedWithAbbreviations) - "
        + "\(pitchDetail.maxPrice.roundedWithAbbreviations)"
        
        if let location = pitchDetail.pitchAdress.location,
           let latitude = CLLocationDegrees(location.latitude),
           let longtitude = CLLocationDegrees(location.longitude) {
            guard let distance = LocationManager.shared
                    .distanceTo(toLocation: CLLocation(
                                    latitude: latitude,
                                    longitude: longtitude)) else {
                return
            }
            
            distanceLabel.text = "\(String(format: "%.0f", distance/1000))Km"
        } else {
            distanceLabel.text = "error"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
    }
    
    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.masksToBounds = false
        bottomUIView.makeRadius(radius: 10, mask: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        fieldImageView.layer.cornerRadius = 10
    }
}
