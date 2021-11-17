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
    }
    
    private func setupView() {
        registerButton.makeRadius(radius: 10)
        scrollView.makeRadius(radius: 25, mask: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    @IBAction func registerDidTapped(_ sender: Any) {
        
    }
}
