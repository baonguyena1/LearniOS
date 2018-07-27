//
//  ViewController.swift
//  Examples
//
//  Created by Bao Nguyen on 7/26/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import TabSwipeControl

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let items = ["Home", "Category", "Main", "New tab with long text in content", "Other tab"]
        let tabSwipeToolbar = TabSwipeNavigation(items, delegate: self)
        tabSwipeToolbar.insertIntoRootViewController(self)
    }
}

extension ViewController: TabSwipeNagivationDelegate {
    func tabSwipeNavigation(_ tabSwipeNagivation: TabSwipeNavigation, controllerAt index: Int) -> UIViewController {
        print(index)
        let viewController = UIViewController()
        if index % 2 == 0 {
            viewController.view.backgroundColor = .red
        } else {
            viewController.view.backgroundColor = .green
        }
        return viewController
    }
    
}

