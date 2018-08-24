//
//  UserProfileViewModel.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import Moya
import Moya_ModelMapper
import RxOptional
import RxSwift

struct UserProfileViewModel {
    let provider: MoyaProvider<GitHub>
    let username: String
    
    func getUser() -> Observable<User?> {
        return self.provider.rx
            .request(GitHub.userProfile(username: username))
            .debug()
            .mapOptional(to: User.self)
            .asObservable()
    }
}
