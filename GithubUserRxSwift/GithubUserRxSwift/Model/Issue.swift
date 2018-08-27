//
//  Issue.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

struct Issue {
    
    let identifier: Int
    let number: Int
    let title: String
    let body: String
    
    init?(json: [String: Any]) {
        do {
            if let identifier = json["id"] as? Int,
                let number = json["number"] as? Int,
                let title = json["title"] as? String,
                let body = json["body"] as? String {
                
                self.identifier = identifier
                self.number = number
                self.title = title
                self.body = body
            } else {
                throw ResponseError.invalidJSONFormat
            }
        } catch {
            return nil
        }
    }
}
