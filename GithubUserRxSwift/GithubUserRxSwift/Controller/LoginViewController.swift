//
//  LoginViewController.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/22/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    fileprivate var loginViewModel: LoginViewModel!
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginViewModel = LoginViewModel()
        
        self.usernameTextField
            .rx.text
            .map { $0 ?? "" }
            .bind(to: self.loginViewModel.usernameStream)
            .disposed(by: disposeBag)
        
        self.passwordTextField
            .rx.text
            .map { $0 ?? "" }
            .bind(to: self.loginViewModel.passwordStream)
            .disposed(by: disposeBag)
        
        self.loginViewModel.isValidStream
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.loginButton
            .rx.tap
            .asDriver()
            .throttle(1.0)
            .drive(onNext: {
                print("tap")
        }).disposed(by: disposeBag)
    }

}

