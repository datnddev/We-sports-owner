//
//  TicketCollectionViewCell.swift
//  WeSports
//
//  Created by datNguyem on 19/11/2021.
//

import UIKit
import DropDown

final class TicketCollectionViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var rootContainer: UIView!
    @IBOutlet private weak var topLeftUIView: UIView!
    @IBOutlet weak var topRightUIView: UIView!
    @IBOutlet weak var dayAndMonthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var sportsImageView: UIImageView!
    @IBOutlet weak var sportLabel: UILabel!
    private let currentDate = Date()
    private let pitchTypes = PitchType.dummyData()
    private let pitchTypeDropDown = DropDown()
    private var currentPitchType: PitchType? = nil {
        didSet {
            guard let currentPitchType = currentPitchType else { return }
            sportsImageView.image = UIImage(named: currentPitchType.icon!)
            sportLabel.text = currentPitchType.type
        }
    }
    @IBAction func bookingDidTapped(_ sender: Any) {
    }
    
    func configure() {
        dayAndMonthLabel.text = "\(currentDate.formatDate(format: "dd")) tháng \(currentDate.formatDate(format: "MM"))"
        yearLabel.text = "\(currentDate.formatDate(format: "yyyy"))"
        dayOfWeekLabel.text = "\(currentDate.formatDate(format: "EEEE"))"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        configure()
        setupDropDown()
        setupAction()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawTicket()
        drawDottedLine(start: CGPoint(x: 18, y: bounds.height/2),
                       end: CGPoint(x: bounds.maxX-18, y: bounds.height/2))

        drawDottedLine(start: CGPoint(x: bounds.width/2, y: bounds.minY),
                       end: CGPoint(x: bounds.width/2, y: bounds.height/2))
    }
    
    private func drawTicket() {
        let ticketShapeLayer = CAShapeLayer()
        ticketShapeLayer.frame = self.bounds
        ticketShapeLayer.fillColor = UIColor.white.cgColor
        let ticketShapePath = UIBezierPath(roundedRect: ticketShapeLayer.bounds, cornerRadius: 18)
        
        let leftArcPath = UIBezierPath(arcCenter: CGPoint(x: 0, y: ticketShapeLayer.frame.height/2),
                                       radius: 18,
                                       startAngle:  CGFloat(Double.pi / 2),
                                       endAngle: CGFloat(Double.pi + Double.pi / 2),
                                       clockwise: false)
        leftArcPath.close()
        
        let rightArcPath = UIBezierPath(arcCenter: CGPoint(x: ticketShapeLayer.frame.width, y: ticketShapeLayer.frame.height/2),
                                        radius: 18,
                                        startAngle:  CGFloat(Double.pi / 2),
                                        endAngle: CGFloat(Double.pi + Double.pi / 2),
                                        clockwise: true)
        rightArcPath.close()
        
        ticketShapePath.append(leftArcPath)
        ticketShapePath.append(rightArcPath.reversing())
        
        ticketShapeLayer.path = ticketShapePath.cgPath
        rootContainer.layer.addSublayer(ticketShapeLayer)

        layer.shadowPath = ticketShapePath.cgPath
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    }
        
    private func setupDropDown() {
        currentPitchType = pitchTypes[0]
        pitchTypeDropDown.anchorView = topRightUIView
        pitchTypeDropDown.dataSource = pitchTypes.compactMap{ $0.type }
        pitchTypeDropDown.direction = .bottom
        pitchTypeDropDown.bottomOffset = CGPoint(x: 0, y: topRightUIView.bounds.height)
        pitchTypeDropDown.cellNib = PitchTypeTableViewCell.nib
        pitchTypeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? PitchTypeTableViewCell else { return }
            cell.dropImageView.image = UIImage(named: self.pitchTypes[index].icon!)
        }
        pitchTypeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let self = self else { return }
            self.currentPitchType = self.pitchTypes[index]
        }
    }
    
    private func setupAction() {
        topRightUIView.isUserInteractionEnabled = true
        topRightUIView.addGestureRecognizer(UITapGestureRecognizer(
                                                target: self,
                                                action: #selector(pitchTypeDidTapped)))
    }
    
    @objc
    private func pitchTypeDidTapped() {
        pitchTypeDropDown.show()
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3]

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}
