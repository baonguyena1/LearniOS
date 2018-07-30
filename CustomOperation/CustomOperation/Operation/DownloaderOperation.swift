//
//  DownloaderOperation.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/27/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class DownloaderOperation: Operation {
    
    enum State: String {
        case ready = "Ready"
        case executing = "Executing"
        case finished = "Finished"
        fileprivate var keyPath: String {
            return "is" + self.rawValue
        }
    }
    
    // MARK: - properties
    
    var photo: PhotoRecord!
    fileprivate var task: URLSessionDataTask?
    
    var state = State.ready {
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
            self.state = .finished
        } else {
            self.state = .ready
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            self.state = .finished
            return
        }
        self.state = .executing
        photo.state = .downloading
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        task?.cancel()
    }
    
    init(_ photo: PhotoRecord) {
        super.init()
        self.photo = photo
        guard let url = URL(string: photo.urlString) else {
            photo.state = .failed
            super.cancel()
            return
        }

        self.task = URLSession(configuration: .default)
            .dataTask(with: url) { [weak self] (data, response, error) in

            if error != nil || data == nil {
                photo.state = .failed
            } else {
                let image = UIImage(data: data!)
                photo.state = .downloaded
                photo.image = image
            }
            self?.state = .finished
        }
    }
}
