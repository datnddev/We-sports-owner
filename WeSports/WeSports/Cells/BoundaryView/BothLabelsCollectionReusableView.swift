//
//  BothLabelsCollectionReusableView.swift
//  WeSports
//
//  Created by datNguyem on 19/11/2021.
//

import UIKit

class BothLabelsCollectionReusableView: UICollectionReusableView, ReusableView {
    var callBack: (()->Void)?
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var leadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private var trailingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemGray2
        label.textAlignment = .right
        return label
    }()
    
    func configure(leadingText: String?, trailingText: String?) {
        leadingLabel.text = leadingText
        trailingLabel.text = trailingText
    }
    
    func setTintColor(color: UIColor) {
        leadingLabel.textColor = color
        trailingLabel.textColor = color
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func commonInit() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
        stackView.addArrangedSubview(leadingLabel)
        stackView.addArrangedSubview(trailingLabel)
    }
}
