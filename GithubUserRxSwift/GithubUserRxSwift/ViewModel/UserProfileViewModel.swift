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
    
    func getUser(username: String) -> Observable<User> {
        return UserService.getUser(username: username)
    }
}
