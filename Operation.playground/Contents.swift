import UIKit

class AsynchronousOperation: Operation {
    
    enum State: String {
        case Ready
        case Executing
        case Finished
        
        private var keyPath: String {
            get {
                return "is \(self.rawValue)"
            }
        }
    }
    
    var state: State = .Ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: newValue.rawValue)
        }
        
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: oldValue.rawValue)
        }
    }
    
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
    
    override var isExecuting: Bool {
        get {
            return state == .Executing
        }
    }
    
    override var isFinished: Bool {
        get {
            return state == .Finished
        }
    }
    
    override func start() {
        if self.isCancelled {
            state = .Finished
        } else {
            state = .Ready
            main()
        }
    }
    
    override func main() {
        if self.isCancelled {
            state = .Finished
        } else {
            state = .Executing
            //Asynchronous logic (eg: n/w calls) with callback
        }
    }
}

let operation = AsynchronousOperation()
operation.start()


