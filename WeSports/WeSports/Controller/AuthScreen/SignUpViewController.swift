//
//  SignUpViewController.swift
//  WeSports
//
//  Created by datNguyem on 16/11/2021.
//

import UIKit

final class SignUpViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var registerContainer: UIView!
    @IBOutlet private weak var textFieldsContainer: InforTextFields!
    @IBOutlet private weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupAction()
    }
    
    private func setupView() {
        view.layoutIfNeeded()
        activeHandleKeyboard()
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint(x: 0, y: 180), animated: false)
        
        registerButton.makeRadius(radius: 10)
        scrollView.makeRadius(radius: 25,
                              mask: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        textFieldsContainer.nameCustomTextField.textField.tag = 1
        textFieldsContainer.usernameCustomTextField.textField.tag = 2
        textFieldsContainer.phoneCustomTextField.textField.tag = 3
        backImageView.isUserInteractionEnabled = true
    }
    
    private func setupAction() {
        registerContainer.addGestureRecognizer(UITapGestureRecognizer(
                                                target: self, action: #selector(turnOffKeyBoard)))
        textFieldsContainer.nameCustomTextField.textField.addTarget(
            self,
            action: #selector(scrollToPosition(sender:)), for: .editingDidBegin)
        textFieldsContainer.usernameCustomTextField.textField.addTarget(
            self,
            action: #selector(scrollToPosition(sender:)), for: .editingDidBegin)
        textFieldsContainer.phoneCustomTextField.textField.addTarget(
            self,
            action: #selector(scrollToPosition(sender:)), for: .editingDidBegin)
        backImageView.addGestureRecognizer(UITapGestureRecognizer(
                                            target: self,
                                            action: #selector(backDidTapped)))
    }
    
    @objc
    func scrollToPosition(sender: UITextField) {
        switch sender.tag {
        case 1:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case 2:
            scrollView.setContentOffset(CGPoint(x: 0, y: 130), animated: true)
        case 3:
            scrollView.setContentOffset(CGPoint(x: 0, y: 230), animated: true)
        default:
            break
        }
    }
    
    @IBAction func registerDidTapped(_ sender: Any) {
        view.endEditing(true)
        guard let owner = validator() else { return }
        APIManager.shared.postRequest(url: GetUrl.baseUrl(endPoint: .register),
                                      params: owner) { result in
            switch result {
            case .success(let dataResponnse):
                let response = try? JSONDecoder().decode(LoginResponse.self, from: dataResponnse)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.showAlertAuth(title: "Đăng ký thành công",
                                       message: "Kiểm tra email để xác nhận tài khoản") { alert in
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            self.backDidTapped()
                        }))
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc
    private func backDidTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func validator() -> Owner?{
        do {
            let name = try textFieldsContainer.nameCustomTextField
                .textField.validateText(type: .name, for: nil)
            let username = try textFieldsContainer.usernameCustomTextField
                .textField.validateText(type: .username, for: nil)
            let phone = try textFieldsContainer.phoneCustomTextField
                .textField.validateText(type: .phone, for: nil)
            let mail = try textFieldsContainer.mailCustomTextField
                .textField.validateText(type: .mail, for: nil)
            let password = try textFieldsContainer.passwordTextField
                .textField.validateText(type: .password, for: nil)
            let rePassword = try textFieldsContainer.rePassCustomTextField
                .textField.validateText(type: .repassword, for: password)
            let dateRegister = Date().formatDate(format: "dd/MM/yyyy")
            let owner = Owner(id: nil, username: username,
                              name: name, password: rePassword,
                              phone: phone, mail: mail,
                              accountStatus: 1, dateRegister: dateRegister)
            return owner
        } catch {
            let errorMessage = (error as! ValidatorError).message
            print(errorMessage)
            showAlertAuth(title: "Hãy kiểm tra lại", message: errorMessage) { alert in
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
            return nil
        }
    }
}

extension SignUpViewController {
    func activeHandleKeyboard() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                    as? NSValue)?.cgRectValue
        else {
            return
        }
        self.view.frame.origin.y = 0 - keyboardSize.height
        scrollView.isScrollEnabled = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint(x: 0, y: 180), animated: false)
    }
}
