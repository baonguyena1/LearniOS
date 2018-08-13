//
//  PhotoDownload.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/31/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class PhotoDownload: NSObject, ProgressReporting {
    
    private let unitCount: Int64 = 1
    
    var progress: Progress 
    var completionHandler: ((_ image: UIImage?, _ error: Error?) -> Void)?
    
    var downloadTask: URLSessionDownloadTask? {
        return task
    }
    
    fileprivate var task: URLSessionDownloadTask?
    fileprivate var urlString: String
    
    fileprivate var session: URLSession!
    
    init(_ string: String) {
        urlString = string
        progress = Progress(totalUnitCount: unitCount)
    }
    
    func startImport() {
        guard let url = URL(string: urlString) else {
            progress.completedUnitCount = unitCount
            completionHandler?(nil, nil)
            return
        }
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.baon.backgroundTransfer\(Date().timeIntervalSince1970)")
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        configuration.httpMaximumConnectionsPerHost = 1
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        self.task = self.session.downloadTask(with: url)
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

extension PhotoDownload: URLSessionDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first, let originalURL = downloadTask.originalRequest?.url {
            
            let destinationURL = documentDirectory.appendingPathComponent(originalURL.lastPathComponent)
            try? fileManager.removeItem(at: destinationURL)
            do {
                try fileManager.copyItem(at: location, to: destinationURL)
                let image = UIImage(contentsOfFile: destinationURL.path)
                completionHandler?(image, nil)
            } catch let error {
                print("Error:", error.localizedDescription)
                completionHandler?(nil, error)
            }
        } else {
            completionHandler?(nil, nil)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        completionHandler?(nil, error)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown {
            print("NSURLSessionTransferSizeUnknown")
            return
        }
        if self.progress.totalUnitCount != totalBytesExpectedToWrite {
            self.progress.totalUnitCount = totalBytesExpectedToWrite
        }
        OperationQueue.main.addOperation {
            self.progress.completedUnitCount = totalBytesWritten
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            DispatchQueue.global().async {
                
                if appDelegate.backgroundSessionCompletionHandler != nil {
                    let completionHandler = appDelegate.backgroundSessionCompletionHandler
                    appDelegate.backgroundSessionCompletionHandler = nil
                    OperationQueue.main.addOperation {
                        print("background completed!")
                        completionHandler?()
                    }
                }
            }
        }
        
    }
    
}
