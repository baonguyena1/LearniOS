//
//  TabSwipeSegmentControl.swift
//  TabSwipeControl
//
//  Created by Bao Nguyen on 7/26/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

open class TabSwipeSegmentControl: UISegmentedControl {
    
    // MARK: - Public properties
    
    open var indicatorColor: UIColor? {
        didSet {
            self.indicator.backgroundColor = indicatorColor
        }
    }
    
    // MARK: - Private properties
    
    fileprivate var indicator: UIImageView!
    fileprivate var indicatorHeight: CGFloat!
    fileprivate var tabExtraWidth: CGFloat! = 0
    fileprivate var indicatorMinX: CGFloat!
    fileprivate var indicatorWidth: CGFloat!
    
    fileprivate var imageNormalColor: UIColor!
    fileprivate var imageSelectedColor: UIColor!
    
    open override var selectedSegmentIndex: Int {
        didSet {
            self.syncImageTintColor()
        }
    }
    
    // MARK: - Computed properties
    
    private var segments: [UIView] {
        return self.value(forKey: "_segments") as! [UIView]
    }
    
    fileprivate var width: CGFloat {
        var totalWidth: CGFloat = 0
        for segment in self.segments {
            totalWidth = totalWidth + segment.frame.size.width
        }
        return totalWidth
    }
    
    fileprivate var selectedSegment: UIView {
        return self.segments[self.selectedSegmentIndex]
    }
    
    // MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(items: [Any]?) {
        super.init(items: items)
        
        // Added Indicator
        self.indicatorHeight = 3
        self.indicator = UIImageView()
        self.indicator.image?.withRenderingMode(.alwaysTemplate)
        self.indicator.backgroundColor = self.tintColor
        self.indicator.autoresizingMask = .init(rawValue: 0)
        self.addSubview(self.indicator)
        
        self.selectedSegmentIndex = 0
        self.apportionsSegmentWidthsByContent = true
        
        // Customize segmented control
        let normalTitleAttr: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: self.tintColor.withAlphaComponent(0.8),
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)
        ]
        self.setTitleTextAttributes(normalTitleAttr, for: .normal)
        
        let selectedTitleAttr: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: self.tintColor,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)
        ]
        self.setTitleTextAttributes(selectedTitleAttr, for: .selected)
        
        // Disable tint color and divider image
        self.tintColor = .clear
        self.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        // Fix indicator frame
        if (items != nil) {
            self.indicatorMinX = self.getMinXForSegment(at: self.selectedSegmentIndex)
            self.indicatorWidth = self.getWithForSegment(at: self.selectedSegmentIndex)
            self.updateIndicatorWith(true)
        }
        
        self.addTarget(self, action: #selector(segmentTapped(_:)), for: .valueChanged)
    }
    
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var totalWidth: CGFloat = 0
        for segment in self.segments {
            let index = self.segments.index(of: segment)!
            let width = self.getWithForSegment(at: index)
            var segmentRect = segment.frame
            segmentRect.origin.x = totalWidth
            segmentRect.size.width = width + self.tabExtraWidth
            segment.frame = segmentRect
            totalWidth = totalWidth + segmentRect.size.width
        }
        self.tabExtraWidth = 0
        var newRect = rect
        newRect.size.width = totalWidth
        self.frame = newRect
        self.syncImageTintColor()
        
        DispatchQueue.main.async {
            self.indicatorMinX = self.getMinXForSegment(at: self.selectedSegmentIndex)
            self.indicatorWidth = self.getWithForSegment(at: self.selectedSegmentIndex)
            self.updateIndicatorWith(true)
        }
     }
    
    // MARK: - Public function
    open override func didChangeValue(forKey key: String) {
        if key == "selectedSegmentIndex" {
            self.syncImageTintColor()
        }
    }
    
    open func setTabExtraWidth(_ tabExtraWidth: CGFloat) {
        self.tabExtraWidth = tabExtraWidth
        self.setNeedsDisplay()
    }
    
    open func setImageNormal(with color: UIColor) {
        self.imageNormalColor = color
        self.syncImageTintColor()
    }
    
    open func setImageSelected(with color: UIColor) {
        self.imageSelectedColor = color
        self.syncImageTintColor()
    }
    
    open override func setTitleTextAttributes(_ attributes: [AnyHashable : Any]?, for state: UIControlState) {
        super.setTitleTextAttributes(attributes, for: state)
        if state == .normal {
            if let attributes = attributes, let color = attributes[NSAttributedStringKey.foregroundColor] as? UIColor {
                self.setImageNormal(with: color)
            }
        } else if state == .selected {
            if let attributes = attributes, let color = attributes[NSAttributedStringKey.foregroundColor] as? UIColor {
                self.setImageSelected(with: color)
            }
        }
     }
    
    // MARK: - Actions
    
    @objc fileprivate func segmentTapped(_ segment: UISegmentedControl) {
        self.indicatorMinX = self.getMinXForSegment(at: self.selectedSegmentIndex)
        self.indicatorWidth = self.getWithForSegment(at: self.selectedSegmentIndex)
        self.updateIndicatorWith(true)
    }
    
    // MARK: - Private function
    
    fileprivate func getMinXForSegment(at index: Int) -> CGFloat {
        return self.segments[index].frame.minX
    }
    
    fileprivate func getWithForSegment(at index: Int) -> CGFloat {
        return self.segments[index].frame.width
    }
    
    fileprivate func updateIndicatorWith(_ animation: Bool) {
        var indicatorY: CGFloat = 0.0
        indicatorY = self.frame.size.height - self.indicatorHeight
        UIView.animate(withDuration: animation ? 0.3 : 0) {
            
            var rect = self.indicator.frame
            rect.origin.x = self.indicatorMinX
            rect.origin.y = indicatorY
            rect.size.width = self.indicatorWidth
            rect.size.height = self.indicatorHeight
            self.indicator.frame = rect
        }
    }
    
    fileprivate func syncImageTintColor() {
        let segments = self.segments
        for segment in segments {
            for view in segment.subviews {
                if view is UIImageView {
                    if segments.index(of: segment) == self.selectedSegmentIndex {
                        view.tintColor = self.imageSelectedColor
                    } else {
                        view.tintColor = self.imageNormalColor
                    }
                }
            }
        }
    }
    
}
