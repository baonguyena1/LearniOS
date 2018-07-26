//
//  ViewController.swift
//  CustomSegment
//
//  Created by Bao Nguyen on 7/25/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var toolbar: UIToolbar!
    fileprivate var position: UIBarPosition = .top
    fileprivate var toolbarHeight: NSLayoutConstraint!
    
    fileprivate var tabSwipeScrollView: TabSwipeScrollView!
    
    fileprivate var tabSegmentControl: TabSwipeSegmentControl! {
        return tabSwipeScrollView.segmentControl
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addToolbar()
        self.createTabSwipeScrollViewWith(["Home", "Category", "This is a new page", "Next page"])
        self.addToolbarIntoSupperView()
        self.tabSegmentControl.tabExtraWidth = 10
        
        let titleAtt: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.black,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]
        self.tabSegmentControl.setTitleTextAttributes(titleAtt, for: .normal)

        let selectedAtt: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.red,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]
        self.tabSegmentControl.setTitleTextAttributes(selectedAtt, for: .selected)
    }
    
    fileprivate func addToolbar() {
        self.toolbar = UIToolbar()
        self.toolbar.delegate = self
    }
    
    fileprivate func createTabSwipeScrollViewWith(_ items: [Any]) {
        self.tabSwipeScrollView = TabSwipeScrollView(items)
        self.tabSwipeScrollView.clipsToBounds = false
        self.toolbar.addSubview(self.tabSwipeScrollView)
        self.tabSwipeScrollView.segmentControl!.addTarget(self, action: #selector(segmentTapped(_:)), for: .valueChanged)
        
        self.tabSwipeScrollView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: Any] = [
            "tabSwipeScrollView": self.tabSwipeScrollView
        ]
        self.toolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tabSwipeScrollView]|",
                                                                   options: .init(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: views))
        self.toolbar.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tabSwipeScrollView]|",
                                                                   options: .init(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: views))
    }
    
    fileprivate func addToolbarIntoSupperView() {
        self.view.addSubview(self.toolbar)
        self.toolbar.translatesAutoresizingMaskIntoConstraints = false

        var topLayoutGuide:CGFloat = 0.0
        if #available(iOS 11.0, *) {
            topLayoutGuide = self.view.safeAreaInsets.top
        } else {
            topLayoutGuide = self.topLayoutGuide.length
        }
        let metrics = [
            "topLayoutGuide": topLayoutGuide
        ]
        let views: [String: Any] = [
            "toolbar": self.toolbar
        ]
        
        var verticalFormat = "V:-topLayoutGuide-[toolbar]|"
        if self.position == .top || self.position == .topAttached {
            verticalFormat = "V:|-topLayoutGuide-[toolbar]"
        }
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verticalFormat,
                                                                options: .init(rawValue: 0),
                                                                metrics: metrics,
                                                                views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[toolbar]|",
                                                                options: .init(rawValue: 0),
                                                                metrics: nil,
                                                                views: views))
        self.toolbarHeight = NSLayoutConstraint.init(item: self.toolbar,
                                                     attribute: .height,
                                                     relatedBy: .equal,
                                                     toItem: nil,
                                                     attribute: .notAnAttribute,
                                                     multiplier: 1.0,
                                                     constant: 40)
        self.view.addConstraint(self.toolbarHeight)
    }

    @objc
    fileprivate func segmentTapped(_ segmentControl: UISegmentedControl) {
        print(segmentControl.selectedSegmentIndex)
    }
    
    
}


extension ViewController: UIToolbarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }
}
