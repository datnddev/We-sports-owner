//
//  ImagePitchDetailView.swift
//  WeSports
//
//  Created by datNguyem on 05/12/2021.
//

import UIKit

final class ImagePitchDetailView: UIView, ReusableView {
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    var images = [String]() {
        didSet {
            imageCollectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupCollecitonView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupCollecitonView()
    }
    
    private func commonInit() {
        let viewFromXib = loadViewFromNib()
        addSubview(viewFromXib)
        viewFromXib.frame = bounds
    }
    
    private func setupCollecitonView() {
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.register(
            ImageCollectionViewCell.nib,
            forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
}

extension ImagePitchDetailView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch images.isEmpty {
        case true:
            return 1
        case false:
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCollectionViewCell.identifier,
            for: indexPath) as! ImageCollectionViewCell
        if images.isEmpty {
            cell.setDefaultImage()
        } else {
            cell.configure(imageUrl: images[indexPath.row])
        }
        return cell
    }
}

extension ImagePitchDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
