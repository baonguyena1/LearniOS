//
//  ViewController.swift
//  CommandPattern
//
//  Created by Bao Nguyen on 8/9/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

enum CommandAction: Int {
    case equal
    case add
    case sub
    case multiple
    case device
    case clear
}

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var calculator: Calculator!

    override func viewDidLoad() {
        super.viewDidLoad()
        calculator = Calculator()
    }
    
    
    @IBAction func numberTapped(_ sender: UIButton) {
        let oldNum = (display.text! as NSString).doubleValue
        let newNum = (sender.titleLabel!.text! as NSString).doubleValue
        if oldNum == newNum && oldNum == 0 {
            return
        }
        if oldNum == 0 {
            display.text = "\(sender.titleLabel!.text!)"
        } else {
            display.text = "\(display!.text!)\(sender.titleLabel!.text!)"            
        }
    }

    @IBAction func commandButtonTapped(_ sender: UIButton) {
        if let text = display.text, let num = Double(text) {
            var clearDisplay = true
            if let command = CommandAction(rawValue: sender.tag) {
                switch command {
                case .equal:
                    calculator.commandEntered(newValue: num, nextCommand: nil)
                    display.text = "\(calculator.currentValue)"
                    clearDisplay = false
                case .add:
                    calculator.commandEntered(newValue: num, nextCommand: AddCommand())
                case .sub:
                    calculator.commandEntered(newValue: num, nextCommand: SubCommand())
                case .multiple:
                    calculator.commandEntered(newValue: num, nextCommand: MultiplyCommand())
                case .device:
                    calculator.commandEntered(newValue: num, nextCommand: DeviceCommand())
                case .clear:
                    calculator.clear()
                }
                if clearDisplay {
                    display.text = "0"
                }
            }
        }
    }

}

