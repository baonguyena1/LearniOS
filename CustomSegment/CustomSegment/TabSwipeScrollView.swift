//
//  TabSwipeScrollView.swift
//  CustomSegment
//
//  Created by Bao Nguyen on 7/25/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class TabSwipeScrollView: UIScrollView {
    
    var segmentControl: TabSwipeSegmentControl?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ items: [Any]) {
        super.init(frame: .zero)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.setItems(items)
        self.addSubview(self.segmentControl!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.superview != nil {
            self.superview!.bringSubview(toFront: self)
        }
        guard let segmentControl = self.segmentControl else {
            return
        }
        var segmentRect = segmentControl.frame
        segmentRect.size.height = self.frame.size.height
        segmentControl.frame = segmentRect
        
        let contentWidth = max(segmentRect.size.width, self.frame.size.width)
        self.contentSize = CGSize(width: contentWidth, height: self.frame.size.height)
    }
    
    fileprivate func setItems(_ items: [Any]) {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.segmentControl = TabSwipeSegmentControl(items: items)
    }
    
}
