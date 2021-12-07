//
//  HomeViewController.swift
//  WeSports
//
//  Created by datNguyem on 18/11/2021.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController {
    @IBOutlet weak var topUIView: UIView!
    @IBOutlet weak var notificationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var homeTableView: UITableView!
    private var promos = Promo.dummyData()
    private var pitchs = [PitchDetail]() {
        didSet {
            homeTableView.reloadSections(IndexSet(integer: 2), with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        loadData()
    }
    
    private func setupView() {
        topUIView.makeRadius(radius: 40,
                             mask: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
    }
    
    private func loadData() {
        self.locationLabel.text = "Vị trí không xác định"
        if LocationManager.shared.getCurrentLocation() != nil {
            LocationManager.currentCity { city in
                self.locationLabel.text = city.nameWithType
                self.loadPitchs(city: city)
                LocationManager.shared.stopUpdatingLocation()
            }
        }
    }
    
    private func loadPitchs(city: City) {
        let params = ["addressCity": city]
        APIManager.shared.postRequest(url: GetUrl.baseUrl(endPoint: .listPitch),
                                      params: params) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(ListPitchResponse.self, from: data)
                    guard response.status == 1 else {
                        return
                    }
                    DispatchQueue.main.async {
                        for i in 0..<response.data.count {
                            guard let location = response.data[i].pitchAddress.location,
                                  let latitude = CLLocationDegrees(location.latitude),
                                  let longtitude = CLLocationDegrees(location.longitude) else { return }
                            let cllocation = CLLocation(latitude: latitude, longitude: longtitude)
                            guard let distance = LocationManager.shared.distanceTo(toLocation: cllocation) else {
                                return
                            }
                            if distance >= 0 && distance <= 20000 {
                                self.pitchs.append(response.data[i])
                            }
                        }
                    }
                } catch {
                    print(String(describing: error))
                }
            case .failure(let error):
                print("error when get list \(error)")
            }
        }
    }
    
    private func setupTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(HomeTableViewCell.nib,
                               forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as! HomeTableViewCell
        if indexPath.section == 0 {
            cell.configure(section: .promo)
        } else if indexPath.section == 1 {
            cell.configure(section: .ticket)
        } else {
            cell.configure(section: .nearByField)
            cell.nearByPitch = pitchs
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.bounds.height * 0.3
        case 1:
            return tableView.bounds.height * 0.35
        case 2:
            return 240
        default:
            return 0
        }
    }
}
