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
        scrollView.makeRadius(radius: 25, mask: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    private func setupAction() {
        registerContainer.addGestureRecognizer(UITapGestureRecognizer(
                                                target: self, action: #selector(turnOffKeyBoard)))
    }
    
    @IBAction func registerDidTapped(_ sender: Any) {
        
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
