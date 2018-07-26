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
        var topLayoutGuide: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            topLayoutGuide = self.view.safeAreaInsets.top
        } else {
            topLayoutGuide = self.topLayoutGuide.length
        }
        
        let metrics: [String: Any] = [
            "topLayoutGuide": topLayoutGuide
        ]
        let items = ["Home", "Category", "Main", "New tab", "Other tab"]
        let tabSwipeSegmentControl = TabSwipeSegmentControl(items: items)
        tabSwipeSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tabSwipeSegmentControl)
        
        let views: [String: Any] = [
            "tabSwipeSegmentControl": tabSwipeSegmentControl
        ]
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-topLayoutGuide-[tabSwipeSegmentControl(44)]",
                                                                options: .init(rawValue: 0),
                                                                metrics: metrics,
                                                                views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tabSwipeSegmentControl]",
                                                                options: .init(rawValue: 0),
                                                                metrics: metrics,
                                                                views: views))
    }


}

