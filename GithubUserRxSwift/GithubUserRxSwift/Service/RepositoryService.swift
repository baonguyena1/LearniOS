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
    
    static func findRepository(by name: String) -> Observable<Repositoty?> {
        return responseJson(api: .repo(fullname: name))
            .map {
                guard let json = $0 as? [String: Any], let repository = Repositoty.init(json: json) else {
                    return nil
                }
                return repository
            }
            .debug()
    }
    
    static func findIssues(by repository: Repositoty) -> Observable<[Issue]> {
        return responseJson(api: .issues(reposiitoryFullName: repository.fullName))
            .debug()
            .map { result -> [Issue]? in
                guard let jsonArray = result as? [[String: Any]] else {
                    return nil
                }
                let issues = jsonArray.compactMap { Issue.init(json: $0) }
                return issues
            }
            .replaceNilWith([])
    }
    
    static func trackIssues(by name: String) -> Observable<[Issue]> {
        return findRepository(by: name)
            .debug()
            .flatMap { (repository) -> Observable<[Issue]> in
                if let repository = repository {
                    return findIssues(by: repository)
                }
                return Observable.create({ (observer) -> Disposable in
                    observer.onNext([])
                    observer.onCompleted()
                    return Disposables.create()
                })
            }
    }
    
    static func issueOfUser(username: String) -> Observable<[RepositoryInfo]> {
        return responseJson(api: .repos(username: username))
            .debug()
            .map {
                guard let jsonArray = $0 as? [[String: Any]] else {
                    return []
                }
                let repositoriesInfo = jsonArray.compactMap { RepositoryInfo.init(json: $0) }
                return repositoriesInfo
            }
    }
    
}
