//
//  InforPitchViewPager.swift
//  WeSports
//
//  Created by datNguyem on 06/12/2021.
//

import UIKit

final class InforPitchViewPager: UIView {
    lazy var viewPager: ViewPager = {
        let viewPager = ViewPager(
            tabSizeConfiguration: .fillEqually(height: 50, spacing: 0)
        )
        
//        let view1 = AboutPitchView(pitch: <#T##PitchDetail#>)
//
//        let view2 = UIView()
//        view2.backgroundColor = .systemPink
        
        viewPager.tabbedView.tabs = [
            AppTabItemView(title: "Thông tin"),
            AppTabItemView(title: "Đánh giá")
        ]
//        viewPager.pagedView.pages = [
//            view1,
//            view2
//        ]
        viewPager.translatesAutoresizingMaskIntoConstraints = false
        return viewPager
    }()
    var pitch: PitchDetail? {
        didSet {
            commonInit()
        }
    }
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func commonInit() {
        guard let pitch = pitch else {
            return
        }
        let view1 = AboutPitchView(pitch: pitch)
        
        let view2 = UIView()
        view2.backgroundColor = .systemPink
        viewPager.pagedView.pages = [view1, view2]
        addSubview(viewPager)
        NSLayoutConstraint.activate([
            viewPager.widthAnchor.constraint(equalTo: widthAnchor),
            viewPager.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            viewPager.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewPager.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])
    }
}
