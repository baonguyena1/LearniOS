//
//  TabSwipeScrollView.swift
//  TabSwipeControl
//
//  Created by Bao Nguyen on 7/26/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

open class TabSwipeScrollView: UIScrollView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    // MARK: - Private properties
    fileprivate var _tabSwipeSegmentControl: TabSwipeSegmentControl!
    
    // MARK: - Public properties
    open var tabSwipeSegmentControl: TabSwipeSegmentControl! {
        get {
            return _tabSwipeSegmentControl
        }
    }
    
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(_ items: [Any]?) {
        super.init(frame: .zero)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.setItems(items)
        self.addSubview(_tabSwipeSegmentControl)
    }
    
    // MARK: - Public function
    open func setItems(_ items: [Any]?) {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        _tabSwipeSegmentControl = TabSwipeSegmentControl(items: items)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if self.superview != nil {
            self.superview?.bringSubview(toFront: self)
        }
        var segmenRect = _tabSwipeSegmentControl.frame
        segmenRect.size.height = self.frame.height
        _tabSwipeSegmentControl.frame = segmenRect
        
        let contentWidth = max(segmenRect.width, self.frame.width + 1)
        self.contentSize = CGSize(width: contentWidth, height: self.frame.height)
        
    }
}
