//
//  PageFooterCollectionReusableView.swift
//  WeSports
//
//  Created by datNguyem on 19/11/2021.
//

import UIKit

class PageFooterCollectionReusableView: UICollectionReusableView, ReusableView {
    static let NotificationChangeCurrentPage = "ChangeCurrentPageFooterCollectionReusableView"
    
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = .yellow
        return pageControl
    }()
    
    var setCurrentPage: Int = 0 {
        didSet {
            pageControl.currentPage = setCurrentPage
        }
    }
    
    func configure(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        NotificationCenter.default.addObserver(self, selector: #selector(changeCurrentPage(_:)),
                                               name: Notification.Name(Self.NotificationChangeCurrentPage),
                                               object: nil)
    }
    
    @objc
    private func changeCurrentPage(_ notification: Notification) {
        let page = notification.object as! Int?
        guard let page = page else { return }
        pageControl.currentPage = page
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func commonInit() {
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            pageControl.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: pageControl.trailingAnchor, constant: 0),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}
