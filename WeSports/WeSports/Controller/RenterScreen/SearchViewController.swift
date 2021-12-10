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
    private var sideMenu: SideMenuUIView = {
        let sideMenu = SideMenuUIView(frame: CGRect(
                                        x: UIScreen.main.bounds.width,
                                        y: 0,
                                        width: UIScreen.main.bounds.width - 50,
                                        height: UIScreen.main.bounds.height))
        return sideMenu
    }()
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
            if LocationManager.shared.getCurrentLocation() == nil {
                return
            }
            self.pitchs = self.pitchs.sorted(by: { pitch1, pitch2 in
                guard let location1 = pitch1.pitchAddress.location,
                      let latitude1 = CLLocationDegrees(location1.latitude),
                      let longtitude1 = CLLocationDegrees(location1.longitude),
                      let location2 = pitch2.pitchAddress.location,
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
        }
    }
    
    private func setupAction() {
        sortUIView.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(sortingDidTapped)))
        filterUIView.isUserInteractionEnabled = true
        filterUIView.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(filterDidTapped)))
    }
    
    @objc
    private func sortingDidTapped() {
        sortDropDown.show()
    }
    
    @objc
    private func filterDidTapped() {
        //blur effect when open menu
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        //menu
        view.addSubview(sideMenu)
        
        sideMenu.cancelAction = {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseOut) {
                
                self.sideMenu.frame.origin.x = UIScreen.main.bounds.width
            }
            blurEffectView.removeFromSuperview()
        }
        
        sideMenu.filterAction = { filter in
            self.pitchs.removeAll()
            self.getPitchs(filter: filter) { pitchsResponse in
                var pitchsFilter = pitchsResponse
                //filter by price
                if let minPrice = filter.minPrice,
                   let maxPrice = filter.maxPrice {
                    pitchsFilter = pitchsFilter.filter{
                        $0.minPrice >= minPrice &&
                            $0.minPrice <= maxPrice &&
                            $0.maxPrice >= minPrice &&
                            $0.maxPrice <= maxPrice
                    }
                }
                //filter by distance
                if filter.distance < 99 {
                    pitchsFilter = pitchsFilter.filter({ pitchDetail in
                        guard let location = pitchDetail.pitchAddress.location,
                              let latitude = CLLocationDegrees(location.latitude),
                              let longtitude = CLLocationDegrees(location.longitude) else { return false}
                        let cllocation = CLLocation(latitude: latitude, longitude: longtitude)
                        guard let distancePitch = LocationManager.shared.distanceTo(toLocation: cllocation) else {
                            return false
                        }
                        return distancePitch/1000 <= filter.distance
                    })
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.pitchs = pitchsFilter
                }
            }
        }
        //animated
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut) {
            
            self.sideMenu.frame.origin.x = self.view.frame.size.width - self.sideMenu.bounds.width
        }
    }
        
    private func loadData() {
        LocationManager.currentCity { city in
            let filter = Filter(addressCity: city,
                                addressDistrict: nil,
                                minPrice: nil,
                                maxPrice: nil,
                                distance: 0)
            self.getPitchs(filter: filter) { pitchsResponse in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.pitchs = pitchsResponse
                        .filter { $0.pitchAddress.location != nil}
                        .sorted(by: {$0.minPrice < $1.minPrice})
                }
            }
            LocationManager.shared.stopUpdatingLocation()
        }
    }
    
    private func getPitchs(filter: Filter, completion: (([PitchDetail]) -> Void)?) {
        APIManager.shared.postRequest(url: GetUrl.baseUrl(endPoint: .listPitch), params: filter) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(ListPitchResponse.self, from: data)
                    guard response.status == 1 else {
                        return
                    }
                    completion?(response.data)
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

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pitchVC = PitchDetailViewController(
            nibName: "PitchDetailViewController",
            bundle: nil)
        pitchVC.pitch = pitchs[indexPath.item]
        let navVC = UINavigationController(rootViewController: pitchVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
}
