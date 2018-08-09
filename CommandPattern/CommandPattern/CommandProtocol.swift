//
//  CommandProtocol.swift
//  CommandPattern
//
//  Created by Bao Nguyen on 8/9/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

protocol CommandProtocol {
    func execute(firstValue: Double, secondValue:Double) -> Double
}

struct AddCommand: CommandProtocol {
    func execute(firstValue: Double, secondValue: Double) -> Double {
        return firstValue + secondValue
    }
}

struct SubCommand: CommandProtocol {
    func execute(firstValue: Double, secondValue: Double) -> Double {
        return firstValue - secondValue
    }
}

struct MultiplyCommand: CommandProtocol {
    func execute(firstValue: Double, secondValue: Double) -> Double {
        return firstValue * secondValue
    }
}

struct DeviceCommand: CommandProtocol {
    func execute(firstValue: Double, secondValue: Double) -> Double {
        return firstValue / secondValue
    }
}


struct Calculator {
    
    var currentValue: Double = 0
    var lastCommand: CommandProtocol?
    
    mutating func clear() {
        currentValue = 0.0
        lastCommand = nil
    }
    
    mutating func commandEntered(newValue: Double, nextCommand: CommandProtocol?) {
        defer {
            self.lastCommand = nextCommand
        }
        if let lastCommand = self.lastCommand {
            
            if lastCommand is DeviceCommand && newValue == 0 {
                return
            }
            self.currentValue =  lastCommand.execute(firstValue: currentValue, secondValue: newValue)
        } else {
            self.currentValue = newValue
        }
    }
}
