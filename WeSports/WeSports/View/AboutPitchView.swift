//
//  AboutPitchView.swift
//  WeSports
//
//  Created by datNguyem on 06/12/2021.
//

import UIKit

final class AboutPitchView: UIView, ReusableView {
    //MARK: Init
    init(pitch: PitchDetail) {
        self.pitch = pitch
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Properties
    var pitch: PitchDetail
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(
            InforPitchCollectionViewCell.nib,
            forCellWithReuseIdentifier: InforPitchCollectionViewCell.identifier)
        collectionView.register(
            BothLabelsCollectionReusableView.self,
            forSupplementaryViewOfKind: BothLabelsCollectionReusableView.identifier,
            withReuseIdentifier: BothLabelsCollectionReusableView.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: Setup ui
    private func setupUI() {
        addSubview(collectionView)
        backgroundColor = .clear
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout{
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .absolute(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BothLabelsCollectionReusableView.identifier,
            alignment: .top)
        header.contentInsets.top = 5
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension AboutPitchView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return pitch.services?.count ?? 0
        default:
            fatalError("Section not found")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: InforPitchCollectionViewCell.identifier,
            for: indexPath) as! InforPitchCollectionViewCell
        if indexPath.section == 0 {
            cell.titleLabel.text = "\(pitch.pitchOpen) - \(pitch.pitchClose)"
        } else if indexPath.section == 1 {
            var priceText = "\(Double(pitch.minPrice).roundedWithAbbreviations) - "
            priceText.append(Double(pitch.maxPrice).roundedWithAbbreviations)
            cell.titleLabel.text = priceText
        } else if indexPath.section == 2 {
            cell.titleLabel.text = pitch.services![indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: BothLabelsCollectionReusableView.identifier,
            withReuseIdentifier: BothLabelsCollectionReusableView.identifier,
            for: indexPath) as! BothLabelsCollectionReusableView
        if indexPath.section == 0 {
            cell.configure(leadingText: "Thời gian", trailingText: "")
        } else if indexPath.section == 1 {
            cell.configure(leadingText: "Giá", trailingText: "")
        } else if indexPath.section == 2 {
            cell.configure(leadingText: "Thông tin", trailingText: "")
        }
        cell.setTintColor(color: .hex_211A2C)
        return cell
    }
}
