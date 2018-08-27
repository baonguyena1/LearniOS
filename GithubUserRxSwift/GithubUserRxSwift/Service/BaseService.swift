//
//  BaseService.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxOptional

struct ResponseError {
    static let invalidJSONFormat = NSError(domain: "", code: 600, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON Format"])
}

struct BaseService {
    
    static func getUser(api: GitHub) -> Observable<[String: Any]> {
        
        return Observable.create({ (observer) -> Disposable in
            
            let request = APIProvider.shared.request(api, completion: { (result) in
                do {
                    switch result {
                    case .success(let response):
                        let json =  try response.mapJSON()
                        if let jsonDict = json as? [String: Any] {
                            observer.onNext(jsonDict)
                            observer.onCompleted()
                        } else {
                            throw ResponseError.invalidJSONFormat
                        }
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
