//
//  Repository.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

struct Repositoty {
    
    let identifier: Int
    let language: String
    let name: String
    let fullName: String
    
    init?(json: [String: Any]) {
        do {
            if let identifier = json["id"] as? Int,
            let language = json["language"] as? String,
            let name = json["name"] as? String,
            let fullName = json["full_name"] as? String {
                
                self.identifier = identifier
                self.language = language
                self.name = name
                self.fullName = fullName
            } else {
                throw ResponseError.invalidJSONFormat
            }
        } catch {
            return nil
        }
    }
}
