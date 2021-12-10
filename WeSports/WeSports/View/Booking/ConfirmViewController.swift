//
//  ConfirmViewController.swift
//  WeSports
//
//  Created by datNguyem on 09/12/2021.
//

import UIKit
import FSCalendar

class ConfirmViewController: UIViewController {
    @IBOutlet private weak var pitchImageView: UIImageView!
    @IBOutlet private weak var nameLbl: UILabel!
    @IBOutlet private weak var streetLbl: UILabel!
    @IBOutlet private weak var cityLbl: UILabel!
    @IBOutlet private weak var paymentInfoCollectionView: UICollectionView!
    @IBOutlet private weak var paymentWayView: UIView!
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var ownerPhoneLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    var pitch: PitchDetail?
    var total: Double = 0
    var bookings = [TimePerRent]() {
        didSet {
            paymentInfoCollectionView.reloadData()
            if !bookings.isEmpty {
                total = 0
                bookings.forEach({ total += $0.price })
                totalLbl.text = "Tổng tiền: \(total.convertToVND()!)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFirstLoad()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func setupCollectionView() {
        paymentInfoCollectionView.delegate = self
        paymentInfoCollectionView.dataSource = self
        paymentInfoCollectionView.register(
            TimePerRentCollectionViewCell.nib,
            forCellWithReuseIdentifier: TimePerRentCollectionViewCell.identifier)
    }
    
    private func setupUI() {
        pitchImageView.contentMode = .scaleAspectFill
    }
    
    private func setupFirstLoad() {
        guard let pitch = pitch, let images = pitch.images else { return }
        if images.isEmpty {
            pitchImageView.image = UIImage(named: "fieldDefault")
        } else {
            pitchImageView.loadImageUrl(path: images[0])
        }
        nameLbl.text = pitch.pitchName
        streetLbl.text = "\(pitch.pitchAddress.street!)"
        cityLbl.text = "\(pitch.pitchAddress.district!.nameWithType), \(pitch.pitchAddress.city!.name)"
        ownerLbl.text = "Chủ sân: \(pitch.pitchOwner!.name)"
        ownerPhoneLbl.text = "Số điện thoại: \(pitch.pitchOwner!.phone)"
    }
}

extension ConfirmViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimePerRentCollectionViewCell.identifier,
            for: indexPath) as! TimePerRentCollectionViewCell
        cell.configure(timePerRent: bookings[indexPath.item], time: pitch!.timePerRent)
        return cell
    }
}

extension ConfirmViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
