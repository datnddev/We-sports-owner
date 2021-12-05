//
//  SideMenuUIView.swift
//  WeSports
//
//  Created by datNguyem on 04/12/2021.
//

import UIKit
import DropDown

final class SideMenuUIView: UIView, ReusableView {
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var cityUIView: UIView!
    @IBOutlet private weak var districtLabel: UILabel!
    @IBOutlet private weak var districtUIView: UIView!
    @IBOutlet private weak var minPriceTextField: UITextField!
    @IBOutlet private weak var maxPriceTextField: UITextField!
    @IBOutlet private weak var distanceSlider: UISlider!
    @IBOutlet private weak var distanceLabel: UILabel!
    @IBOutlet private weak var cancelBtn: UIButton!
    @IBOutlet private weak var filterBtn: UIButton!
    private let cityDropDown = DropDown()
    private let districtDropDown = DropDown()
    var cancelAction: (() -> Void)? = nil
    var filterAction: ((Filter) -> Void)? = nil
    private var cityNames: [String] = {
        var cityNames = LocationManager.citys.map({$0.name})
        cityNames.insert("Tất cả", at: 0)
        return cityNames
    }()
    private var districts: [District]? {
        guard let city = currentCity,
              let path = Bundle.main.path(forResource: "\(city.code)", ofType: "json")
        else {
            return nil
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                options: .mappedIfSafe)
            return try JSONDecoder().decode([District].self, from: data)
        } catch {
            print(String(describing: error))
        }
        return nil
    }
    private var districtNames: [String] {
        guard let districts = districts else { return [] }
        var districtNames = districts.map({$0.name})
        districtNames.insert("Tất cả", at: 0)
        return districtNames
    }
    private var currentCity: City? = nil
    private var currentDistrict: District? = nil
    private var minPrice: Double? = nil
    private var maxPrice: Double? = nil
    private var distance = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    @IBAction func sliderValueDidChanged(_ sender: UISlider) {
        distance = Int(sender.value)
        distanceLabel.text = sender.value < 99 ? "<\(Int(sender.value))Km" : "+99Km"
    }
    
    private func commonInit() {
        let viewFromXib = loadViewFromNib()
        addSubview(viewFromXib)
        viewFromXib.frame = bounds
        
        cityUIView.makeBorder(width: 1, color: UIColor.gray)
        districtUIView.makeBorder(width: 1, color: UIColor.gray)
        minPriceTextField.makeBorder(width: 1, color: UIColor.gray)
        maxPriceTextField.makeBorder(width: 1, color: UIColor.gray)
        
        minPriceTextField.keyboardType = .numberPad
        maxPriceTextField.keyboardType = .numberPad
        
        distanceSlider.value = 10
        distanceLabel.text = "<10Km"
        
        setupCityDropDown()
        setupDistrictDropDown()
        
        setupAction()
    }
    
    func setupAction() {
        cityUIView.isUserInteractionEnabled = true
        cityUIView.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(cityDidTapped)))
        districtUIView.isUserInteractionEnabled = true
        districtUIView.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(districtDidTapped)))
    }
    
    @IBAction func cancelDidTapped(_ sender: Any) {
        cancelAction?()
    }
    
    @IBAction func filterDidTapped(_ sender: Any) {
        if let minPriceText = minPriceTextField.text,
           !minPriceText.isEmpty,
           let maxPriceText = maxPriceTextField.text,
           !maxPriceText.isEmpty {
            sortingPrice(minPrice: minPriceText, maxPrice: maxPriceText)
            minPriceTextField.text = "\(String(format: "%.0f", minPrice!))"
            maxPriceTextField.text = "\(String(format: "%.0f", maxPrice!))"
        } else {
            minPrice = nil
            maxPrice = nil
            minPriceTextField.text = ""
            maxPriceTextField.text = ""
        }
        let filter = Filter(
            addressCity: currentCity,
            addressDistrict: currentDistrict,
            minPrice: minPrice,
            maxPrice: maxPrice,
            distance: Double(distance))
        filterAction?(filter)
        cancelAction?()
    }
    
    private func sortingPrice(minPrice: String, maxPrice: String) {
        guard let min = Double(minPrice),
              let max = Double(maxPrice) else { return }
        if min > max {
            self.minPrice = max
            self.maxPrice = min
        } else {
            self.minPrice = min
            self.maxPrice = max
        }
    }
    
    private func setupCityDropDown() {
        cityDropDown.anchorView = cityUIView
        cityDropDown.direction = .bottom
        cityDropDown.bottomOffset = CGPoint(x: 0, y: cityUIView.bounds.height)
        cityDropDown.offsetFromWindowBottom = 300
        cityDropDown.dataSource = cityNames
        cityDropDown.selectionAction = { [weak self] index, item in
            guard let self = self else { return }
            switch index {
            case 0:
                self.currentCity = nil
            default:
                self.currentCity = LocationManager.citys[index-1]
            }
            self.cityLabel.text = self.cityNames[index]
        }
    }
    
    @objc
    private func cityDidTapped() {
        cityDropDown.show()
    }
    
    private func setupDistrictDropDown() {
        districtDropDown.anchorView = districtUIView
        districtDropDown.direction = .bottom
        districtDropDown.bottomOffset = CGPoint(x: 0, y: cityUIView.bounds.height)
        districtDropDown.offsetFromWindowBottom = 300
        districtDropDown.selectionAction = { index, item in
            switch index {
            case 0:
                self.currentDistrict = nil
            default:
                self.currentDistrict = self.districts?[index-1]
            }
            self.districtLabel.text = self.districtNames[index]
        }
    }
    
    @objc
    private func districtDidTapped() {
        guard let districts = districts else { return }
        districtDropDown.dataSource = districtNames
        districtDropDown.show()
    }
}
