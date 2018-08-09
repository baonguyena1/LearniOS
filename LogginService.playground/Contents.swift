import UIKit

protocol LoggerProfileProtocol {
    var loggerProfileId: String { get }
    func writeLog(level: String, message: String)
}

extension LoggerProfileProtocol {
    func getCurrentDateString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY hh:mm"
        return dateFormatter.string(from: date)
    }
}

struct LoggerNull: LoggerProfileProtocol {
    let loggerProfileId: String = "logger.null"
    
    func writeLog(level: String, message: String) {
        
    }
}

struct LoggerConsole: LoggerProfileProtocol {
    let loggerProfileId: String = "logger.console"
    func writeLog(level: String, message: String) {
        
    }
}
