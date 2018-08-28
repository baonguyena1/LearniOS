//
//  RepositoryInfo.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/28/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

struct RepositoryInfo {
    let id: Double
    let nodeId: String
    let name: String
    let fullname: String
    let owner: User
    
    init?(json: [String: Any]) {
        if let id = json["id"] as? Double,
            let nodeId = json["node_id"] as? String,
            let name = json["name"] as? String,
            let fullname = json["full_name"] as? String,
            let ownerJson = json["owner"] as? [String: Any],
            let user = User(json: ownerJson) {
            
            self.id = id
            self.nodeId = nodeId
            self.name = name
            self.fullname = fullname
            self.owner = user
        } else {
            return nil
        }
    }
}
