//
//  IssueTrackerModel.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import Moya
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {
    
    let provider: MoyaProvider<GitHub>
    let repositoryName: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryName
            .observeOn(MainScheduler.instance)
            .flatMap { (name) -> Observable<Repositoty> in
                print("--->", name)
                return self.findRepository(name: name)
            }
            .flatMap{ (repository) -> Observable<[Issue]?> in
                return self.findIssues(repository: repository)
            }
            .replaceNilWith([])
    }
    
    fileprivate func findIssues(repository: Repositoty) -> Observable<[Issue]?> {
        return self.provider.rx
            .request(GitHub.issues(reposiitoryFullName: repository.fullName))
            .debug()
            .mapOptional(to: [Issue].self)
            .asObservable()
    }
    
    fileprivate func findRepository(name: String) -> Observable<Repositoty> {
        return self.provider.rx
            .request(GitHub.repo(fullname: name)).debug()
            .mapOptional(to: Repositoty.self)
            .asObservable()
            .filterNil()
    }
}
