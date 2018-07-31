//
//  QueueManager.swift
//  CustomOperation
//
//  Created by Bao Nguyen on 7/30/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

struct QueueManager {
    static let shared: QueueManager = QueueManager()
    
    var queue: OperationQueue!
    
    var numberOperation: Int {
        return queue.maxConcurrentOperationCount
    }
    
    private init() {
        queue = OperationQueue()
        queue.name = "QueueManager"
        queue.maxConcurrentOperationCount = 1
    }
    
    func addOperation(_ operation: Operation) {
        self.queue.addOperation(operation)
    }
}
