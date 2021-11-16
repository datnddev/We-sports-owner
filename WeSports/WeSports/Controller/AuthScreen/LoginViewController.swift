//
//  LoginViewController.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var loginView: UIView!
    @IBOutlet private weak var userCustomTextField: CustomTextField!
    @IBOutlet private weak var passwordCustomTextField: CustomTextField!
    @IBOutlet private weak var forgotPasswordLabel: UILabel!
    @IBOutlet private weak var registerStackView: UIStackView!
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }
    
    private func setupView() {
        loginView.makeRadius(radius: 25, mask: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        userCustomTextField.textField.placeholder = "Nhập email"
        passwordCustomTextField.textField.placeholder = "Nhập mật khẩu"
        
        passwordCustomTextField.textField.isSecureTextEntry  = true
        loginButton.makeRadius(radius: 10)
        
        forgotPasswordLabel.isUserInteractionEnabled = true
        registerStackView.isUserInteractionEnabled = true
    }
    
    private func setupAction() {
        forgotPasswordLabel.addGestureRecognizer(UITapGestureRecognizer(
                                                    target: self,
                                                    action: #selector(forgotPasswordDidTapped)))
        registerStackView.addGestureRecognizer(UITapGestureRecognizer(
                                                target: self,
                                                action: #selector(registerDidTapped)))
    }
    
    @IBAction func loginDidTapped(_ sender: Any) {
        guard let username = userCustomTextField.textField.text, !username.isEmpty,
              let password = passwordCustomTextField.textField.text, !password.isEmpty else {
            return
        }
        let paramDic = ["ownerUsername":username, "ownerPassword":password]
        APIManager.shared.postRequest(
            url: GetUrl.baseUrl(endPoint: .login),
            params: paramDic) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    guard let owner = response.owner else { return }
                    UserDefaults.standard.setValue(owner.id, forKey: Constant.loggedKey)
                } catch {
                    print(String(describing: error))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc
    private func registerDidTapped() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc
    private func forgotPasswordDidTapped() {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
