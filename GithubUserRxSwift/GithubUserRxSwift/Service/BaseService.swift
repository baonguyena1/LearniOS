//
//  BaseService.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import Moya_ModelMapper
import RxOptional

struct ResponseError {
    static let invalidJSONFormat = NSError(domain: "", code: 600, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON Format"])
}

protocol BaseService {
    static func responseJson(api: GitHub) -> Observable<Any>
}

extension BaseService {
    
    static func responseJson(api: GitHub) -> Observable<Any> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let request = APIProvider.shared.request(api, completion: { (result) in
                do {
                    switch result {
                    case .success(let response):
                        let json =  try response.mapJSON()
                        observer.onNext(json)
                        observer.onCompleted()
                    case .failure(let error):
                        throw error
                    }
                } catch let error {
                    observer.onError(error)
                    observer.onCompleted()
                }
            })
            return Disposables.create {
                request.cancel()
            }
        })
    }
    
}
