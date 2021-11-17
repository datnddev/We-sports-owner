//
//  InforTextFields.swift
//  WeSports
//
//  Created by datNguyem on 17/11/2021.
//

import UIKit

class InforTextFields: UIView, ReusableView {
    @IBOutlet weak var nameStackView: UIStackView!
    @IBOutlet weak var nameCustomTextField: CustomTextField!
    @IBOutlet weak var usernameStackView: UIStackView!
    @IBOutlet weak var usernameCustomTextField: CustomTextField!
    @IBOutlet weak var phoneStackView: UIStackView!
    @IBOutlet weak var phoneCustomTextField: CustomTextField!
    @IBOutlet weak var mailStackView: UIStackView!
    @IBOutlet weak var mailCustomTextField: CustomTextField!
    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var rePassStackView: UIStackView!
    @IBOutlet weak var rePassCustomTextField: CustomTextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        let viewFromNib = loadViewFromNib()
        addSubview(viewFromNib)
        viewFromNib.frame = bounds
        nameCustomTextField.textField.placeholder = "Họ và tên"
        usernameCustomTextField.textField.placeholder = "Tên đăng nhập"
        phoneCustomTextField.textField.placeholder = "Số điện thoại"
        mailCustomTextField.textField.placeholder = "Email"
        passwordTextField.textField.isSecureTextEntry = true
        rePassCustomTextField.textField.isSecureTextEntry = true
    }
}
