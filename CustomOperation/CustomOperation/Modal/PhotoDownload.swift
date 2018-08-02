//
//  PhotoDownload.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/31/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

class PhotoDownload: NSObject, ProgressReporting {
    
    private let unitCount: Int64 = 1
    
    var progress: Progress 
    var completionHandler: ((_ data: Data?, _ error: Error?) -> Void)?
    
    var downloadTask: URLSessionDataTask? {
        return task
    }
    
    fileprivate var task: URLSessionDataTask?
    fileprivate var urlString: String
    
    fileprivate var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        return URLSession(configuration: configuration)
    }
    
    init(_ string: String) {
        urlString = string
        progress = Progress(totalUnitCount: unitCount)
    }
    
    func startImport() {
        guard let url = URL(string: urlString) else {
            progress.completedUnitCount = unitCount
            return
        }
        task = session.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            OperationQueue.main.addOperation({
                strongSelf.progress.completedUnitCount = strongSelf.progress.completedUnitCount + 1
            })
            strongSelf.completionHandler?(data, error)
        })
    }
    
    func start() {
        downloadTask?.resume()
    }
    
    func cancel() {
        downloadTask?.cancel()
    }
    
    func suppend() {
        task?.suspend()
    }
}
