//
//  APIProvider.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import Moya

struct APIProvider {
    static let shared = MoyaProvider<GitHub>()
}
