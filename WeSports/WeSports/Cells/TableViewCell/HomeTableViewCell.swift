//
//  HomeTableViewCell.swift
//  WeSports
//
//  Created by datNguyem on 28/11/2021.
//

import UIKit
enum HomeSection: Int, CaseIterable {
    case promo
    case ticket
    case nearByField
}

class HomeTableViewCell: UITableViewCell, ReusableView {
    @IBOutlet weak var homeCollectionView: UICollectionView!
    private var homeSection: HomeSection? = nil
    var promos = Promo.dummyData()
    var nearByPitch = [PitchDetail]() {
        didSet {
            homeCollectionView.reloadData()
        }
    }
    var bookAction: ((Filter) -> Void)?
    var pitchDidTap: ((PitchDetail) -> Void)?
    
    func configure(section: HomeSection) {
        homeSection = section
        setupCollectionView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCollectionView() {
        guard let section = homeSection else { return }
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        switch section {
        case .promo:
            homeCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: createPromoSection())
        case .ticket:
            homeCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: createTicketSection())
        case .nearByField:
            homeCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: createNearBySection())
        }
        
        homeCollectionView.register(PromoHomeCollectionViewCell.nib,
                                    forCellWithReuseIdentifier: PromoHomeCollectionViewCell.identifier)
        homeCollectionView.register(TicketCollectionViewCell.nib,
                                    forCellWithReuseIdentifier: TicketCollectionViewCell.identifier)
        homeCollectionView.register(FieldCollectionViewCell.nib,
                                    forCellWithReuseIdentifier: FieldCollectionViewCell.identifier)
        homeCollectionView.register(BlankDataCollectionViewCell.nib,
                                    forCellWithReuseIdentifier: BlankDataCollectionViewCell.identifier)

        homeCollectionView.register(BothLabelsCollectionReusableView.self,
                                    forSupplementaryViewOfKind: BothLabelsCollectionReusableView.identifier,
                                    withReuseIdentifier: BothLabelsCollectionReusableView.identifier)
        homeCollectionView.register(PageFooterCollectionReusableView.self,
                                    forSupplementaryViewOfKind: PageFooterCollectionReusableView.identifier,
                                    withReuseIdentifier: PageFooterCollectionReusableView.identifier)
    }
    
    private func createPromoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(11/18))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(5/18))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: BothLabelsCollectionReusableView.identifier,
                                                                 alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalWidth(1/18))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize,
                                                                 elementKind: PageFooterCollectionReusableView.identifier,
                                                                 alignment: .bottom)
        footer.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header, footer]

        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { visibleItems, point, environment in
            NotificationCenter.default.post(
                name: Notification.Name(PageFooterCollectionReusableView.NotificationChangeCurrentPage),
                object: visibleItems.last!.indexPath.row)
        }
        return section
    }
    
    private func createTicketSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createNearBySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: BothLabelsCollectionReusableView.identifier,
                                                                 alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .paging
        return section
    }
    
    @objc
    private func pitchDidTapped() {
        
    }
}

extension HomeTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch homeSection {
        case .promo:
            return promos.count
        case .ticket:
            return 1
        case .nearByField:
            if nearByPitch.isEmpty {
                return 1
            } else {
                return nearByPitch.count
            }
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch homeSection {
        case .promo:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PromoHomeCollectionViewCell.identifier,
                for: indexPath) as! PromoHomeCollectionViewCell
            cell.configure(promo: promos[indexPath.row])
            return cell
        case .ticket:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TicketCollectionViewCell.identifier,
                for: indexPath) as! TicketCollectionViewCell
            cell.bookingAction = bookAction
            return cell
        case .nearByField:
            if nearByPitch.isEmpty {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: BlankDataCollectionViewCell.identifier,
                    for: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FieldCollectionViewCell.identifier,
                    for: indexPath) as! FieldCollectionViewCell
                cell.configure(pitchDetail: nearByPitch[indexPath.row])
                return cell
            }
        default:
            fatalError("section not found")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == PageFooterCollectionReusableView.identifier {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: PageFooterCollectionReusableView.identifier,
                withReuseIdentifier: PageFooterCollectionReusableView.identifier,
                for: indexPath) as! PageFooterCollectionReusableView
            footer.configure(numberOfPages: 3)
            footer.backgroundColor = .clear
            return footer
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: BothLabelsCollectionReusableView.identifier,
            withReuseIdentifier: BothLabelsCollectionReusableView.identifier,
            for: indexPath) as! BothLabelsCollectionReusableView
        if homeSection == .promo {
            header.configure(leadingText: "Khuyễn mãi", trailingText: "Xem tất cả")
            header.backgroundColor = .clear
        } else if homeSection == .nearByField {
            header.configure(leadingText: "Gần đây", trailingText: "Xem tất cả")
            header.setTintColor(color: .hex_211A2C)
            header.backgroundColor = .clear
        }
        return header
    }
}

extension HomeTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if homeSection == .nearByField {
            pitchDidTap?(nearByPitch[indexPath.item])
        }
    }
}
