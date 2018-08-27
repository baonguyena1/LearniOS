//
//  UserService.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Moya_ModelMapper
import RxOptional

struct UserService: BaseService {
    
    static func getUser(username: String) -> Observable<User> {
        return responseJson(api: .userProfile(username: username)).map {
            if let user = User(json: $0) {
                return user
            } else {
                throw ResponseError.invalidJSONFormat
            }
        }
    }
}
