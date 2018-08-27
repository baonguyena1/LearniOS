//
//  RepositoryService.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

struct RepositotyService: BaseService {
    
    static func findRepository(by name: String) -> Observable<Repositoty> {
        return responseJson(api: .repo(fullname: name)).map {
            guard let json = $0 as? [String: Any], let repository = Repositoty.init(json: json) else {
                throw ResponseError.invalidJSONFormat
            }
            return repository
        }
    }
    
    static func findIssues(by repository: Repositoty) -> Observable<[Issue]> {
        return responseJson(api: .issues(reposiitoryFullName: repository.fullName)).map {
            guard let jsonArray = $0 as? [[String: Any]] else {
                throw ResponseError.invalidJSONFormat
            }
            let issues = jsonArray.compactMap { Issue.init(json: $0) }
            return issues
        }
    }
    
    static func trackIssues(by name: String) -> Observable<[Issue]> {
        return findRepository(by: name)
            .flatMap { repository in
            return findIssues(by: repository)
        }
    }
}
