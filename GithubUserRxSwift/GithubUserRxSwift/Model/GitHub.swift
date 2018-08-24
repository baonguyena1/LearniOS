//
//  Githud.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import Moya

enum GitHub {
    case userProfile(username: String)
    case repos(username: String)
    case repo(fullname: String)
    case issues(reposiitoryFullName: String)
}

extension GitHub: TargetType {
    
    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .userProfile(let username):
            return "/users/\(username.URLEscapedString)"
        case.repos(let username):
            return "/users/\(username.URLEscapedString)/repos"
        case .repo(let fullname):
            return "/repos/\(fullname)"
        case .issues(let reposiitoryFullName):
            return "/repos/\(reposiitoryFullName)/issues"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .repos(_):
            return "{{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}}}".data(using: .utf8)!
        case .userProfile(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: .utf8)!
        case .repo(_):
            return "{\"id\": \"1\", \"language\": \"Swift\", \"url\": \"https://api.github.com/repos/mjacko/Router\", \"name\": \"Router\"}".data(using: .utf8)!
        case .issues(_):
            return "{\"id\": 132942471, \"number\": 405, \"title\": \"Updates example with fix to String extension by changing to Optional\", \"body\": \"Fix it pls.\"}".data(using: .utf8)!
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
