//
//  TabSwipeToolbar.swift
//  TabSwipeControl
//
//  Created by Bao Nguyen on 7/26/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

open class TabSwipeToolbar: UIToolbar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(_ items: [Any]?) {
        super.init(frame: .zero)
        self.createTabSwipeScrollView(items)
    }
    
    fileprivate func createTabSwipeScrollView(_ items: [Any]?) {
        let tabSwipeScrollView = TabSwipeScrollView(items)
        tabSwipeScrollView.clipsToBounds = false
        self.addSubview(tabSwipeScrollView)
        
        tabSwipeScrollView.translatesAutoresizingMaskIntoConstraints = false
        let views: [String: Any] = [
            "tabSwipeScrollView": tabSwipeScrollView
        ]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[tabSwipeScrollView]|",
                                                           options: .init(rawValue: 0),
                                                           metrics: nil,
                                                           views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tabSwipeScrollView]|",
                                                           options: .init(rawValue: 0),
                                                           metrics: nil,
                                                           views: views))
    }
}
