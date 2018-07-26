import UIKit

//protocol VehicleProtocol: class {
//    // MARK: - Vehicle State
//    var speed: Int { get set }
//    func setState(_ state: VehicleState)
//
//    // MARK: - Vehicle Controls
//    func accelerate()
//    func brake()
//    func park()
//
//    // MARK: - State Getters
//    func getSteppedState() -> VehicleState
//    func getMovingState() -> VehicleState
//    func getParkingState() -> VehicleState
//}
//
//protocol VehicleState {
//    init(_ vehicle: VehicleProtocol)
//
//    func accelerate()
//    func brake()
//    func park()
//}
//
//class StoppedState: VehicleState {
//    private weak var vehicle: VehicleProtocol?
//
//    required init(_ vehicle: VehicleProtocol) {
//        self.vehicle = vehicle
//    }
//
//    func accelerate() {
//        self.vehicle?.speed += 5
//        if let movingState = self.vehicle?.getMovingState() {
//            self.vehicle?.setState(movingState)
//        }
//    }
//
//    func brake() {
//        print("Can't brake... Vehicle is already stopped!")
//    }
//
//    func park() {
//        if let parkingState = self.vehicle?.getParkingState() {
//            self.vehicle?.setState(parkingState)
//            parkingState.park()
//        }
//    }
//
//}

class SemaphoreManager {
    let semaphore: DispatchSemaphore!
    var isServicing =  false
    var tasks = [Task]()
    var currentTaskIndex = 0
    var numberThread = 0
    
    init(numberThread: Int) {
        self.numberThread = numberThread
        self.semaphore = DispatchSemaphore(value: numberThread)
    }
    
    func getTasks(tasks: [Task]) {
        self.isServicing = true
        self.tasks = tasks
    }
    
    func startServicing() {
        self.semaphore.wait(timeout: .distantFuture)
        if self.currentTaskIndex > self.tasks.count - 1 {
            // Finish service
        } else {
            let serialQueue = DispatchQueue(label: "semaphoneManager")
            serialQueue.async {
                self.tasks[self.currentTaskIndex].execute({
                    self.nextTask()
                }, completion: {
                    if self.isServicing {
                        self.semaphore.signal()
                    }
                })
            }
        }
    }
    func nextTask() {
        self.currentTaskIndex += 1
        if self.isServicing {
            self.startServicing()
        }
    }
    
    
}

struct Task {
    var id = 0
    var time = 0
    
    typealias completionHandler = () -> Void
    func execute(_ serviceTask: completionHandler, completion: @escaping completionHandler) {
        let serialQueue = DispatchQueue(label: "queue")
        serialQueue.async {
            sleep(UInt32(self.time))
            completion()
        }
        serviceTask()
    }
}
