//
//  SearchViewController.swift
//  WeSports
//
//  Created by datNguyem on 26/11/2021.
//

import UIKit
import CoreLocation
import DropDown

final class SearchViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var pitchCollectionView: UICollectionView!
    @IBOutlet private weak var searchBarTextField: UITextField!
    @IBOutlet private weak var filterContainerView: UIView!
    @IBOutlet private weak var sortUIView: UIView!
    @IBOutlet private weak var sortLabel: UILabel!
    @IBOutlet private weak var filterUIView: UIView!
    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var mapUIView: UIView!
    private let sortDropDown = DropDown()
    private enum SortingKey: Int, CaseIterable {
        case lowestPrice
        case highestPrice
        case distance
        case rating
        
        var title: String {
            switch self {
            case .lowestPrice:
                return "Giá thấp"
            case .highestPrice:
                return "Giá cao"
            case .distance:
                return "Khoảng cách"
            case .rating:
                return "Đánh giá"
            }
        }
    }

    private var pitchs = [PitchDetail]() {
        didSet {
            pitchCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupCollectionView()
        setupSortDropDown()
        setupAction()
        loadData()
    }

    
    private func setupView() {
        containerView.makeRadius(radius: 35, mask: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        filterContainerView.layer.shadowColor = UIColor.black.cgColor
        filterContainerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        filterContainerView.layer.shadowOpacity = 0.2
        filterContainerView.layer.shadowRadius = 20
        filterContainerView.layer.shadowPath = UIBezierPath(rect: filterContainerView.bounds).cgPath
        sortLabel.text = SortingKey(rawValue: 0)?.title
    }
    
    private func setupCollectionView() {
        pitchCollectionView.dataSource = self
        pitchCollectionView.delegate = self
        pitchCollectionView.collectionViewLayout = createLayout()
        pitchCollectionView.register(FieldCollectionViewCell.nib,
                                     forCellWithReuseIdentifier: FieldCollectionViewCell.identifier)
    }
    
    private func setupSortDropDown() {
        sortDropDown.anchorView = sortUIView
        sortDropDown.dataSource = SortingKey.allCases.map{$0.title}
        sortDropDown.direction = .bottom
        sortDropDown.bottomOffset = CGPoint(x: 0, y: sortUIView.bounds.height)
        sortDropDown.selectionAction = { (index: Index, item: String) in
            self.sortLabel.text = SortingKey(rawValue: index)?.title
            self.sortingPitch(sortingKey: SortingKey(rawValue: index)!)
        }
    }
    
    private func sortingPitch(sortingKey: SortingKey) {
        switch sortingKey {
        case .lowestPrice:
            self.pitchs = self.pitchs.sorted(by: {$0.minPrice < $1.minPrice})
        case .highestPrice:
            self.pitchs = self.pitchs.sorted(by: {$0.maxPrice > $1.maxPrice})
        case .distance:
            self.pitchs = self.pitchs.sorted(by: { pitch1, pitch2 in
                guard let location1 = pitch1.pitchAdress.location,
                      let latitude1 = CLLocationDegrees(location1.latitude),
                      let longtitude1 = CLLocationDegrees(location1.longitude),
                      let location2 = pitch2.pitchAdress.location,
                      let latitude2 = CLLocationDegrees(location2.latitude),
                      let longtitude2 = CLLocationDegrees(location2.longitude) else {
                    return false
                }
                guard let distance1 = LocationManager.shared.distanceTo(toLocation: CLLocation(
                                                                    latitude: latitude1,
                                                                    longitude: longtitude1)),
                let distance2 = LocationManager.shared.distanceTo(toLocation: CLLocation(
                                                                    latitude: latitude2,
                                                                    longitude: longtitude2))
                else { return false }
                return distance1 < distance2
            })
        case .rating:
            self.pitchs = self.pitchs.sorted(by: {$0.minPrice < $1.minPrice})
        default:
            break
        }
    }
    
    private func setupAction() {
        sortUIView.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(sortingDidTapped)))
    }
    
    @objc
    private func sortingDidTapped() {
        sortDropDown.show()
    }
    
    private func loadData() {
        currentCity { city in
            self.loadPitchs(city: city)
            LocationManager.shared.stopUpdatingLocation()
        }
    }
    
    private func loadPitchs(city: City) {
        let params = ["addressCity": city]
        APIManager.shared.postRequest(url: GetUrl.baseUrl(endPoint: .listPitch)) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(ListPitchResponse.self, from: data)
                    guard response.message == "Get all pitch success" else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.pitchs = response.data.filter { $0.pitchAdress.location != nil}
                    }
                } catch {
                    print(String(describing: error))
                }
            case .failure(let error):
                print("error when get list \(error)")
            }
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pitchs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FieldCollectionViewCell.identifier,
            for: indexPath) as! FieldCollectionViewCell
        cell.configure(pitchDetail: pitchs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.25) {
            cell.layer.transform = CATransform3DMakeScale(1,1,1)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate { }
