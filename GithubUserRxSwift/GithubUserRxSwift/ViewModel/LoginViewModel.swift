//
//  LoginViewModel.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/22/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct LoginViewModel {
    let usernameVariable: Variable<String>
    let passwordVariable: Variable<String>
    let loginButtonSubject: PublishSubject<Void>
    let disposeBag: DisposeBag
    
    init(disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
        self.usernameVariable = Variable<String>("")
        self.passwordVariable = Variable<String>("")
        self.loginButtonSubject = PublishSubject<Void>()
        
        self.loginButtonSubject
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bind {
                print("tap")
            }
        .disposed(by: self.disposeBag)
    }
    
    var isLoginValidObservable: Observable<Bool> {
        return Observable.combineLatest(usernameVariable.asObservable(), passwordVariable.asObservable()) { username, password in
            return username.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
                && password.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8
        }
    }
}
