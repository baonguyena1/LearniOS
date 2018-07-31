//
//  DownloaderOperation.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit


class DownloaderOperation: Operation, ProgressReporting {
    fileprivate let unitCount: Int64 = 10
    
    fileprivate enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String {
            return "is" + self.rawValue
        }
    }
    
    // MARK: - properties
    
    fileprivate var photo: PhotoRecord
    fileprivate var task: URLSessionDataTask? {
        return photo.downloader?.downloadTask
    }
    var progress: Progress
    
    fileprivate var state = State.ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: state.keyPath)
            didChangeValue(forKey: oldValue.keyPath)
        }
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override func start() {
        if self.isCancelled {
            state = .finished
        } else {
            state = .ready
            photo.downloader?.startImport()
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .finished
            return
        }
        state = .executing
        photo.state = .downloading
        if task != nil {
            task?.resume()
        } else {
            state = .finished
            photo.state = .failed
            photo.image = UIImage(named: "Failed")
        }
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
    
    convenience override init() {
        self.init()
    }
    
    init(_ photoRecord: PhotoRecord) {
        
        photo = photoRecord
        photo.state = .queueing
        progress = Progress(totalUnitCount: unitCount)
        super.init()
        progress.addChild(photo.downloader!.progress, withPendingUnitCount: unitCount)
        photo.downloader?.completionHandler = { [weak self] data, error in
            
            guard let strongSelf = self else { return }

            OperationQueue.main.addOperation({
                strongSelf.progress.completedUnitCount = Int64(strongSelf.progress.completedUnitCount) + 1
            })

            if error != nil || data == nil {
                strongSelf.photo.state = .failed
                strongSelf.photo.image = UIImage(named: "Failed")
            } else {
                let image = UIImage(data: data!)
                strongSelf.photo.state = .downloaded
                strongSelf.photo.image = image
            }
            strongSelf.state = .finished
        }
    }
    
}
