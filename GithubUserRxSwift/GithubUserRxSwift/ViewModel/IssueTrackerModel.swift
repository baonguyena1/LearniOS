//
//  IssueTrackerModel.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxSwift

struct IssueTrackerModel {
    
    let repositoryObservable: Observable<String>
    
    func trackIssues() -> Observable<[Issue]> {
        return repositoryObservable
            .observeOn(MainScheduler.instance)
            .skip(1)
            .flatMap {
                return RepositotyService.trackIssues(by: $0)
            }
    }
}
