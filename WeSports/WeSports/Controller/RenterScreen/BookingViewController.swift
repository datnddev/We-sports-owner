//
//  BookingViewController.swift
//  WeSports
//
//  Created by datNguyem on 07/12/2021.
//

import UIKit
import FSCalendar
import Lottie

final class BookingViewController: UIViewController {
    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var stateView: UIView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var bookingBtn: UIButton!
    @IBOutlet private weak var stepLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    var pitch: PitchDetail?
    private var previousTaskID: UUID?
    
    private var currentStateView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemYellow
        return view
    }()
    
    private var pageView: PagedView = {
        let pageView = PagedView(pages: [])
        pageView.translatesAutoresizingMaskIntoConstraints = false
        return pageView
    }()
    
    private enum State: Int {
        case time = 0
        case confirm = 1
        case booking = 2
        
        var title: String {
            switch self {
            case .time:
                return "Chọn thời gian"
            case .confirm:
                return "Xác nhận"
            case .booking:
                return "Đang đặt sân"
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .time:
                return "Xác nhận"
            case .confirm:
                return "Đặt sân"
            case .booking:
                return "Trở về"
            }
        }
    }
    
    private var currentState: State = .time {
        didSet {
            UIView.animate(withDuration: 0.2) {
                let move = CGAffineTransform(
                    translationX: self.stateView.bounds.width/3*CGFloat(self.currentState.rawValue),
                    y: 0)
                self.currentStateView.transform = move
            }
            stepLabel.text = "Bước \(currentState.rawValue + 1)/3"
            titleLabel.text = "\(currentState.title)"
            bookingBtn.setTitle("\(currentState.buttonTitle)", for: .normal)
        }
    }
    
    let calendarVC = CalendarViewController(nibName: "CalendarViewController", bundle: .main)
    let confirmVC = ConfirmViewController(nibName: "ConfirmViewController", bundle: .main)
    
    let statusView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    private var animationView = AnimationView()
    
    private var rentedTimes = [String]()
    private var activeRentTime = [TimePerRent]() {
        didSet {
            calendarVC.rentTime = activeRentTime
        }
    }
    private var bookings = [TimePerRent]() {
        didSet {
            enableButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }
    
//    MARK: UI
    private func setupUI() {
        bottomView.makeRadius(radius: 25,
                              mask: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        bookingBtn.makeRadius(radius: 20)
        
        stateView.makeRadius(radius: 5)
        stateView.clipsToBounds = true
        stateView.addSubview(currentStateView)
        currentStateView.frame.size = CGSize(width: stateView.bounds.width/3,
                                             height: stateView.bounds.height)
        currentStateView.frame.origin.x = stateView.bounds.width/3 * 0
        
        calendarVC.delegate = self
        calendarVC.calendarDelegate = self
        confirmVC.pitch = pitch
        createPage()
        
        getData(date: Date())
    }
    
    private func createPage() {
        view.addSubview(pageView)
        pageView.collectionView.backgroundColor = .clear
        pageView.collectionView.isScrollEnabled = false
        
        NSLayoutConstraint.activate([
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            pageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: pageView.trailingAnchor, constant: 15),
            bookingBtn.topAnchor.constraint(equalTo: pageView.bottomAnchor, constant: 10)
        ])
    
        pageView.pages = [calendarVC.view, confirmVC.view, statusView]

        
    }
    
    //MARK: Action
    private func setupAction() {
        backImageView.isUserInteractionEnabled = true
        backImageView.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(backDidTapped)))
    }
    
    @IBAction func bookingDidTapped(_ sender: Any) {
        switch currentState {
        case .time:
            pageView.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                                 at: .centeredHorizontally, animated: true)
            currentState = .confirm
            confirmVC.bookings = bookings
        case .confirm:
            currentState = .booking
            bookingDidTapped()
        case .booking:
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func bookingDidTapped() {
        let renterId = UserDefaults.standard.string(forKey: Constant.loggedKey)!
        let pitchId = pitch!.id!
        var bookingTime = [String]()
        var total: Double = 0
        bookings.forEach { timePerRent in
            bookingTime.append(timePerRent.time.components(separatedBy: " ")[1])
            total += timePerRent.price
        }
        let bill = Bill(id: nil,
                        pitchId: pitchId,
                        renterId: renterId,
                        timeRent: bookingTime,
                        total: total,
                        status: 0,
                        date: calendarVC.calendar.selectedDate!.formatDate(format: "dd/MM/yyyy"))
        pageView.collectionView.scrollToItem(
            at: IndexPath(item: 2, section: 0),
            at: .centeredHorizontally, animated: true)
        
        animationView = .init(name: "load")
        animationView.frame = statusView.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        statusView.addSubview(animationView)
        animationView.play()
        
        APIManager.shared.postRequest(
            url: GetUrl.baseUrl(endPoint: .addBill),
            params: bill) { result in
            switch result {
            case .success(let data):
                do {
                    let billResponse = try JSONDecoder().decode(BillResponse.self,
                                                            from: data)
                    print(billResponse)
                    if billResponse.status == 1 {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.titleLabel.text = "Đặt sân thành công"
                            self.animationView.animation = Animation.named("success")
                            self.animationView.loopMode = .playOnce
                            self.animationView.play()
                        }
                    } else if billResponse.status == 4 {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.loadFailedAnimation()
                            self.titleLabel.text = "Oops, đã có người đặt sân trước bạn rồi"
                        }
                    }
                } catch {
                    print(String(describing: error))
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.loadFailedAnimation()
                    }
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.loadFailedAnimation()
                }
            }
        }
    }
    
    private func loadFailedAnimation() {
        titleLabel.text = "Đặt sân thất bại"
        animationView.animation = Animation.named("failed")
        animationView.loopMode = .playOnce
        animationView.play()
    }
    
    private func loadSuccessAnimation() {
        titleLabel.text = "Đặt sân thành công"
        animationView.animation = Animation.named("success")
        animationView.loopMode = .playOnce
        animationView.play()
    }
    
    @objc
    private func backDidTapped() {
        switch currentState {
        case .time:
            navigationController?.popViewController(animated: true)
        case .confirm:
            pageView.collectionView.scrollToItem(
                at: IndexPath(item: 0, section: 0),
                at: .centeredHorizontally,
                animated: true)
            currentState = .time
        case .booking:
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func getData(date: Date) {
        guard let pitchId = pitch?.id else {
            return
        }
        
        if let previousTaskID = previousTaskID {
            APIManager.shared.cancelTask(with: previousTaskID)
        }
        
        activeRentTime.removeAll()
        let params = ["_id": pitchId]
        let taskID = APIManager.shared.postRequest(
            url: GetUrl.baseUrl(endPoint: .billByPitch),
            params: params) { result in
            switch result {
            case .success(let data):
                do {
                    let listBillResponse = try JSONDecoder().decode(ListBillResponse.self, from: data)
                    if let listBill = listBillResponse.data, !listBill.isEmpty {
                        self.rentedTimes = listBill
                            .filter{ $0.date == date.formatDate(format: "dd/MM/yyyy")}
                            .map{ $0.timeRent }
                            .flatMap { $0 }
                    }
                    self.generateRentTime(selectedDate: date)
                } catch {
                    print(String(describing: error))
                }
            case .failure(let error):
                print("Booking: \(error)")
            }
            self.previousTaskID = nil
        }
        previousTaskID = taskID
    }
    
    private func generateRentTime(selectedDate: Date) {
        let dayOfSelected = selectedDate.formatDate(format: "dd/MM/yyyy")
        var getRentTime = [TimePerRent]()
        pitch?.prices.forEach({ price in
            let timeStartStr = "\(dayOfSelected) \(price.start)"
            let timeEndStr = "\(dayOfSelected) \(price.end)"
            var timeStart = timeStartStr.date(format: "dd/MM/yyyy HH:mm",
                                              localeStr: "vi_VN")
            let timeEnd = timeEndStr.date(format: "dd/MM/yyyy HH:mm",
                                            localeStr: "vi_VN")
            while timeStart < timeEnd {
                getRentTime.append(
                    TimePerRent(time: timeStart.formatDate(format: "dd/MM/yyyy HH:mm"),
                                price: price.cost,
                                isAvailable: checkActiveTime(time: timeStart))
                )
                timeStart.addTimeInterval(TimeInterval(pitch!.timePerRent * 60))
            }
            activeRentTime = getRentTime
        })
    }
    
    private func checkActiveTime(time: Date) -> Bool {
        let timeStr = time.formatDate(format: "HH:mm")
        return !rentedTimes.contains(timeStr) && time > Date()
    }
    
    private func enableButton() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.bookings.isEmpty {
                self.bookingBtn.backgroundColor = .systemGray3
                self.bookingBtn.isUserInteractionEnabled = false
            } else {
                self.bookingBtn.backgroundColor = .yellow
                self.bookingBtn.isUserInteractionEnabled = true
            }
        }
    }
}

extension BookingViewController: CalendarViewControllerDelegate {
    func didSelectedTime(indexs: [Int]) {
        var currentBooking = [TimePerRent]()
        indexs.forEach {
            currentBooking.append(activeRentTime[$0])
        }
        bookings = currentBooking
        enableButton()
    }
}

extension BookingViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        bookings.removeAll()
        getData(date: date)
    }
}
