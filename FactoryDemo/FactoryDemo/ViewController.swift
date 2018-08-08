//
//  ViewController.swift
//  FactoryDemo
//
//  Created by Bao Nguyen on 8/7/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVisibleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if UserPreferences.shared.isPasswordVisible() {
            passwordVisibleSwitch.isOn = true
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordVisibleSwitch.isOn = false
            passwordTextField.isSecureTextEntry = true
        }
    }

    @IBAction func passwordVisibleswitched(_ sender: UISwitch) {
        let isOn = sender.isOn
        passwordTextField.isSecureTextEntry = !isOn
        UserPreferences.shared.setPasswordVisibity(isOn)
    }
    
}

