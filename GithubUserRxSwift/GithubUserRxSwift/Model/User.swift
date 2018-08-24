//
//  User.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import Mapper

struct User: Mappable {
    let login: String
    let id: Double
    let avatarUrl: String
    let name: String
    
    init(map: Mapper) throws {
        try login = map.from("login")
        try id = map.from("id")
        try avatarUrl = map.from("avatar_url")
        try name = map.from("name")
    }
}
