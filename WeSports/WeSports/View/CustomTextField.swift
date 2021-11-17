//
//  CustomTextField.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import UIKit

class CustomTextField: UIView {
    private let identifier = "CustomTextField"
    @IBOutlet weak var leadingImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    @IBInspectable var placeholder: String? = "Nhập nội dung" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    
    @IBInspectable var leadingIcon: UIImage? {
        didSet {
            guard let leadingIcon = leadingIcon else { return }
            leadingImageView.image = leadingIcon
        }
    }
    
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            layer.masksToBounds = masksToBounds
        }
    }
    
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = radius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let containerView = loadNib()
        containerView.frame = bounds
        addSubview(containerView)
        textField.placeholder = placeholder
    }
    
    private func loadNib() -> UIView {
        return UINib(nibName: identifier, bundle: nil)
            .instantiate(withOwner: self, options: nil).first as! UIView
    }
}
