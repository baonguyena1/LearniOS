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

//let operation = AsynchronousOperation()
//operation.start()

let initialIndices = Set(0..<5)
let expandedIndices = initialIndices.union([2, 3, 6, 6, 7, 7])

var attendess = Set(0..<5)
let visitors: Set = [1, 5, 7]
attendess.formUnion(visitors)

let employees = Set(0..<5)
let neighbors: Set = [1, 2, 3]
employees.subtracting(neighbors)

var employees_2 = Set(0..<5)
let neighbors_2: Set = [1, 2, 3]
employees_2.subtract(neighbors_2)


struct Sports: OptionSet {
    let rawValue: Int
    
    static let none = Sports(rawValue: 0)
    static let running = Sports(rawValue: 1<<0)
    static let cycling = Sports(rawValue: 1<<1)
    static let swimming = Sports(rawValue: 1<<2)
    static let fencing = Sports(rawValue: 1<<3)
    static let shooting = Sports(rawValue: 1<<4)
    static let horseJumping = Sports(rawValue: 1<<5)
}

let triathlon: Sports = [.swimming, .cycling, .running]
triathlon.contains(.swimming)
triathlon.contains(.fencing)

extension Sports {
    static let modernPentathlon: Sports = [.swimming, .fencing, .horseJumping, .shooting, .running]
}

let commonEvents = triathlon.intersection(.modernPentathlon)
commonEvents.contains(.swimming)
commonEvents.contains(.cycling)

let test: Sports = [.none, .running]
test.contains(.none)
triathlon.contains(.none)

struct Schedule: OptionSet {
    let rawValue: Int
    
    static let monday       = Schedule(rawValue: 1 << 0)
    static let tuesday      = Schedule(rawValue: 1 << 1)
    static let wednesday    = Schedule(rawValue: 1 << 2)
    static let thursday     = Schedule(rawValue: 1 << 3)
    static let friday       = Schedule(rawValue: 1 << 4)
    static let saturday     = Schedule(rawValue: 1 << 5)
    static let sunday       = Schedule(rawValue: 1 << 6)
}
