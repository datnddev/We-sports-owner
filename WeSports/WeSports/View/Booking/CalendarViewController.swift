//
//  CalendarViewController.swift
//  WeSports
//
//  Created by datNguyem on 09/12/2021.
//

import UIKit
import FSCalendar

final class CalendarViewController: UIViewController {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var timeCollectionView: UICollectionView!
    var delegate: CalendarViewControllerDelegate?
    var calendarDelegate: FSCalendarDelegate?
    var rentTime = [TimePerRent]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.timeCollectionView.reloadData()
            }
        }
    }
    var selectedRent = [TimePerRent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()

    }
    
    private func setupUI() {
        guard let delegate = calendarDelegate else { return }
        calendar.delegate = delegate
        calendar.dataSource = self
        calendar.locale = Locale(identifier: "vi_VN")
        calendar.select(Date())
    }
    
    private func setupCollectionView() {
        timeCollectionView.delegate = self
        timeCollectionView.dataSource = self
        timeCollectionView.allowsMultipleSelection = true
        timeCollectionView.register(
            TimePriceCollectionViewCell.nib,
            forCellWithReuseIdentifier: TimePriceCollectionViewCell.identifier)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3 - 5,
                      height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let items = collectionView.indexPathsForSelectedItems?.compactMap{ $0.item }
        guard let indexs = items else { return }
        delegate?.didSelectedTime(indexs: indexs)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let items = collectionView.indexPathsForSelectedItems?.compactMap{ $0.item }
        guard let indexs = items else { return }
        delegate?.didSelectedTime(indexs: indexs)
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rentTime.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimePriceCollectionViewCell.identifier,
            for: indexPath) as! TimePriceCollectionViewCell
        cell.configure(timePerRent: rentTime[indexPath.item])
        return cell
    }
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}
