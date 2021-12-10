//
//  PitchDetailViewController.swift
//  WeSports
//
//  Created by datNguyem on 05/12/2021.
//

import UIKit
import CoreLocation

class PitchDetailViewController: UIViewController {
    @IBOutlet private weak var imagePitchUIView: ImagePitchDetailView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var favoriteUIView: UIView!
    @IBOutlet private weak var backUIView: UIView!
    @IBOutlet private weak var heartImageView: UIImageView!
    @IBOutlet private weak var pitchDetailUIView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var distanceUIView: UIView!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var mapImageView: UIImageView!
    @IBOutlet private weak var streetLabel: UILabel!
    @IBOutlet private weak var openMapLabel: UILabel!
    @IBOutlet private weak var bookingBtn: UIButton!
    @IBOutlet private weak var viewPager: InforPitchViewPager!
    var pitch: PitchDetail?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func loadData() {
        guard let pitch = pitch else {
            return
        }
        
        if let images = pitch.images, !images.isEmpty {
            imagePitchUIView.images = images
            pageControl.numberOfPages = images.count
        }
        
        nameLabel.text = pitch.pitchName
        cityLabel.text = "\(pitch.pitchAddress.district!.nameWithType), \(pitch.pitchAddress.city!.name)"
        streetLabel.text = "\(pitch.pitchAddress.street!)"
        
        if let location = pitch.pitchAddress.location,
           let latitude = CLLocationDegrees(location.latitude),
           let longitude = CLLocationDegrees(location.longitude){
            let cllocation = CLLocation(latitude: latitude, longitude: longitude)
            let distance = LocationManager.shared.distanceTo(toLocation: cllocation)
            distanceLabel.text = "\(String(format: "%.1f", distance!/1000)) Km"
        } else {
            distanceUIView.isHidden = true
        }
        
        viewPager.pitch = pitch
    }
    
    private func setupView() {
        backUIView.makeCircle()
        favoriteUIView.makeCircle()
        pitchDetailUIView.makeRadius(radius: 40, mask: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        distanceUIView.makeRadius(radius: 8)
        mapImageView.contentMode = .scaleAspectFill
        bookingBtn.makeRadius(radius: 10)
    }
    
    private func setupAction() {
        backUIView.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(backDidTapped)))
        openMapLabel.isUserInteractionEnabled = true
        openMapLabel.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(openMap)))
    }
    
    //MARK: Action
    @IBAction func bookingDidTapped(_ sender: Any) {
        let bookingVC = BookingViewController(nibName: "BookingViewController", bundle: .main)
        bookingVC.pitch = pitch
        navigationController?.pushViewController(bookingVC, animated: true)
    }
    
    @objc
    private func backDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func openMap() {
        print("open")
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            guard let location = pitch?.pitchAddress.location else {
                return
            }
            var url = "comgooglemaps://?center="
            url.append(location.latitude)
            url.append(",")
            url.append(location.longitude)
            url.append("&zoom=14&views=traffic")
            UIApplication.shared.openURL(URL(string: url)!)
        } else {
          print("Can't use comgooglemaps://");
        }
    }
}
