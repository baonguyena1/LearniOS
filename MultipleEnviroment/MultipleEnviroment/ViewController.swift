//
//  ViewController.swift
//  MultipleEnviroment
//
//  Created by Bao Nguyen on 8/9/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG1
            print("DEBUG_ENVIRONMENT")
        #elseif DEV
            print("DEV_ENVIRONMENT")
        #elseif PROD
            print("PROD_ENVIRONMENT")
        #else
            print("OTHDER")
        #endif
    }


}

