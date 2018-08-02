//
//  ViewController.swift
//  NetService
//
//  Created by Bao Nguyen on 8/2/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BrowserEngine.shared.startSearchService()
    }

}

