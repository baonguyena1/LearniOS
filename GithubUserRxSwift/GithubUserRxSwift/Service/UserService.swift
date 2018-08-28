//
//  UserService.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

struct UserService: BaseService {
    
    static func getUser(username: String) -> Observable<User> {
        return responseJson(api: .userProfile(username: username))
            .debug()
            .map {
                if let json = $0 as? [String: Any],  let user = User(json: json) {
                    return user
                } else {
                    throw ResponseError.invalidJSONFormat
                }
            }
    }
}
