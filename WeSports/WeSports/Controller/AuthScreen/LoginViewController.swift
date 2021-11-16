//
//  LoginViewController.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var userCustomTextField: CustomTextField!
    @IBOutlet private weak var passwordCustomTextField: CustomTextField!
    @IBOutlet private weak var forgotPasswordLabel: UILabel!
    @IBOutlet private weak var registerStackView: UIStackView!
    @IBOutlet private weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        userCustomTextField.textField.placeholder = "Nhập email"
        passwordCustomTextField.textField.placeholder = "Nhập mật khẩu"
        
        passwordCustomTextField.textField.isSecureTextEntry  = true
        loginButton.makeRadius(radius: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
