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
        self.loginViewModel = LoginViewModel(disposeBag: self.disposeBag)
        self.usernameTextField.text = "a"
        self.passwordTextField.text = "123456789"
        
        self.usernameTextField
            .rx.text
            .map { $0 ?? "" }
            .bind(to: self.loginViewModel.usernameVariable)
            .disposed(by: disposeBag)
        
        self.passwordTextField
            .rx.text
            .map { $0 ?? "" }
            .bind(to: self.loginViewModel.passwordVariable)
            .disposed(by: disposeBag)
        
//        self.loginButton
//            .rx.tap
//            .bind(to: self.loginViewModel.loginButtonSubject)
//            .disposed(by: disposeBag)
        
        self.loginViewModel.isLoginValidObservable
            .bind(to: self.loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.loginButton
            .rx.tap
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bind {
                let searchViewController = SearchViewController.instantiate()
                self.navigationController?.pushViewController(searchViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }

}

