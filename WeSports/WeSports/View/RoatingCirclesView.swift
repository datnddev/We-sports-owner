//
//  RoatingCirclesView.swift
//  WeSports
//
//  Created by datNguyem on 18/11/2021.
//

import Foundation
import UIKit

class RoatingCircleView: UIView {
    let circle1 = UIView(frame: CGRect(x: UIScreen.main.bounds.width/2 - 80,
                                       y: UIScreen.main.bounds.height/2,
                                       width: 60, height: 60))
    let circle2 = UIView(frame: CGRect(x: UIScreen.main.bounds.width / 2 + 20,
                                       y: UIScreen.main.bounds.height / 2,
                                       width: 60, height: 60))
    
    let positions = [CGRect(x: UIScreen.main.bounds.width/2 - 70,
                            y: UIScreen.main.bounds.height/2,
                            width: 60, height: 60),
                     CGRect(x: UIScreen.main.bounds.width/2 - 40,
                            y: UIScreen.main.bounds.height/2,
                            width: 70, height: 70),
                     CGRect(x: UIScreen.main.bounds.width/2 + 10,
                            y: UIScreen.main.bounds.height/2,
                            width: 60, height: 60),
                     CGRect(x: UIScreen.main.bounds.width/2 - 40,
                            y: UIScreen.main.bounds.height/2,
                            width: 50, height: 50)
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black.withAlphaComponent(0.5)
        
        circle1.backgroundColor = UIColor.hex_211A2C.withAlphaComponent(0.9)
        circle1.layer.cornerRadius = circle1.frame.height / 2
        circle1.layer.zPosition = 2
        
        circle2.backgroundColor = .yellow.withAlphaComponent(0.9)
        circle2.layer.cornerRadius = circle2.frame.height / 2
        circle2.layer.zPosition = 1
        
        addSubview(circle1)
        addSubview(circle2)
    }
    
    func animate(_ circle: UIView, counter: Int) {
        var counter = counter
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear) {
            circle.frame = self.positions[counter]
            circle.layer.cornerRadius = circle.frame.height / 2
            
            switch counter {
            case 1:
                if circle == self.circle1 {
                    self.circle1.layer.zPosition = 2
                }
            case 3:
                if circle == self.circle1 {
                    self.circle1.layer.zPosition = 0
                }
            default:
                break
            }
        } completion: { (completion) in
            switch counter {
            case 0...2:
                counter += 1
            case 3:
                counter = 0
            default:
                break
            }
            self.animate(circle, counter: counter)
        }
    }
    
    deinit {
        print("Roating deinit")
    }
}
