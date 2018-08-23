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
    let usernameStream: Variable<String>
    let passwordStream: Variable<String>
    
    init() {
        self.usernameStream = Variable<String>("")
        self.passwordStream = Variable<String>("")
    }
    
    var isValidStream: Observable<Bool> {
        return Observable.combineLatest(usernameStream.asObservable(), passwordStream.asObservable()) { username, password in
            return username.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 && password.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8
        }
    }
}
