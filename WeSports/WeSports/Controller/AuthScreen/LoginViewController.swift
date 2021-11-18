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
        guard let param = validator() else { return }
        APIManager.shared.postRequest(
            url: GetUrl.baseUrl(endPoint: .login),
            params: param) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    switch response.status {
                    case LoginStatus.notVerify.rawValue:
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.showAlertAuth(
                                title: "Tài khoản chưa được xác minh",
                                message: "Gửi lại mã xác nhận"){ alert in
                                alert.addTextField { textfield in
                                    textfield.placeholder = "Nhập email"
                                }
                                alert.addAction(UIAlertAction(title: "Gửi lại mã xác nhận",
                                                              style: .default, handler: nil))
                                let cancelAlert = UIAlertAction(title: "Kiểm tra lại email",
                                                                style: .destructive, handler: nil)
                                alert.addAction(cancelAlert)
                            }
                        }
                    case LoginStatus.fail.rawValue:
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.showAlertAuth(
                                title: "Đăng nhập thất bại",
                                message: "Kiểm tra lại tên đăng nhập và mật khẩu"){ alert in
                                alert.addAction(UIAlertAction(title: "OK",
                                                              style: .default, handler: nil))
                            }
                        }
                    case LoginStatus.succes.rawValue:
                        guard let owner = response.owner else { return }
                        UserDefaults.standard.setValue(owner.id, forKey: Constant.loggedKey)
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.changeRootView(vc: RootViewController.mainRootView())
                        }
                    default:
                        break
                    }
                } catch {
                    print(String(describing: error))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func validator() -> Dictionary<String, String>?{
        do {
            let username = try userCustomTextField.textField.validateText(
                type: .username, for: nil)
            let password = try passwordCustomTextField.textField.validateText(
                type: .password, for: nil)
            return ["ownerUsername":username, "ownerPassword":password]
        } catch {
            showAlertAuth(title: "Hãy kiểm tra lại",
                          message: (error as! ValidatorError).message) { alert in
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            return nil
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
