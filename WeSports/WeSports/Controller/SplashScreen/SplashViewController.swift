//
//  SplashViewController.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import UIKit

final class SplashViewController: UIViewController {
    @IBOutlet private weak var splashCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var nextImageView: UIImageView!
    @IBOutlet private weak var skipLabel: UIButton!
    private let splashData = SplashModel.dataSplash
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(true, forKey: Constant.firstLoginKey)
        setupView()
        setupCollectionView()
        setupAction()
    }
    
    private func setupAction() {
        nextImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextDidTapped)))
    }
    
    @objc
    private func nextDidTapped() {
        if pageControl.currentPage < splashData.count - 1{
            pageControl.currentPage += 1
            splashCollectionView.setContentOffset(
                CGPoint(x: splashCollectionView.bounds.size.width * CGFloat(pageControl.currentPage), y: 0),
                                                  animated: true)
        } else {
            changeRootView(vc: RootViewController.loginRootView())
        }
    }
    
    @IBAction func skipDidTapped(_ sender: Any) {
        changeRootView(vc: RootViewController.loginRootView())
    }
    
    private func setupView() {
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = splashData.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .systemYellow
        
        nextImageView.isUserInteractionEnabled = true
        nextImageView.makeCircle()
        
        skipLabel.isUserInteractionEnabled = true
    }
    
    private func setupCollectionView() {
        splashCollectionView.register(SplashCollectionViewCell.nib,
                                      forCellWithReuseIdentifier: SplashCollectionViewCell.identifier)
        splashCollectionView.dataSource = self
        splashCollectionView.delegate = self
        splashCollectionView.collectionViewLayout = createLayout()
        splashCollectionView.showsHorizontalScrollIndicator = false
        splashCollectionView.isPagingEnabled = true
        splashCollectionView.backgroundColor = .hex_211A2C
    }
    
    private func createLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }
}

extension SplashViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return splashData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SplashCollectionViewCell.identifier,
                                                      for: indexPath) as! SplashCollectionViewCell
        cell.configure(splash: splashData[indexPath.row])
        return cell
    }
}

extension SplashViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    }
}
