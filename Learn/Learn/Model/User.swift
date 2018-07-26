//
//  User.swift
//  Learn
//
//  Created by Bao Nguyen on 7/17/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let username: String
    let email: String
    
    init(with json: JSON) {
        if let id = json["_id"] as? String {
            self.id = id
        } else {
            self.id = ""
        }
        if let username = json["username"] as? String {
            self.username = username
        } else {
            self.username = ""
        }
        if let email = json["email"] as? String {
            self.email = email
        } else {
            self.email = ""
        }
    }
}
