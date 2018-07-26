//
//  TabSwipeSegmentControl.swift
//  CustomSegment
//
//  Created by Bao Nguyen on 7/25/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class TabSwipeSegmentControl: UISegmentedControl {
    
    var indicatorHeight:CGFloat!
    var indicator: UIImageView!
    var indicatorMinX: CGFloat!
    var indicatorWidth: CGFloat!
    
    fileprivate var imageNormalColor: UIColor!
    fileprivate var imageSelectedColor: UIColor!
    
    var tabExtraWidth: CGFloat! = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override var selectedSegmentIndex: Int {
        didSet {
            super.selectedSegmentIndex = selectedSegmentIndex
            self.syncImageTintColor()
        }
    }
    
    var segments: [UIView]! {
        return self.value(forKey: "_segments") as? [UIView]
    }
    var width: CGFloat!  {
        var width: CGFloat = 0;
        for segment in self.segments {
            width = width + segment.frame.width
        }
        return width
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        
        self.indicatorHeight = 3
        self.selectedSegmentIndex = 0
        self.apportionsSegmentWidthsByContent = true
        self.indicator = UIImageView()
        self.indicator.image?.withRenderingMode(.alwaysTemplate)
        
        self.indicator.backgroundColor = self.tintColor
        self.indicator.autoresizingMask = .init(rawValue: 0)
        self.addSubview(self.indicator)
        
        // Customize segmented control
        let titleAttr: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: self.tintColor.withAlphaComponent(0.8),
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)
        ]
        self.setTitleTextAttributes(titleAttr, for: .normal)

        let selectedTittleAttr: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: self.tintColor,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)
            ]
        self.setTitleTextAttributes(selectedTittleAttr, for: .selected)
//
//        // Disable tint color and divider image
        self.tintColor = .clear
        self.setDividerImage(UIImage(),
                             forLeftSegmentState: .normal,
                             rightSegmentState: .normal,
                             barMetrics: .default)
        
        // Fix indicator frame
        if (items != nil) {
            self.indicatorMinX = self.getMinXForSegmentAt(self.selectedSegmentIndex)
            self.indicatorWidth = self.getWidthForSegmentAt(self.selectedSegmentIndex)
            self.updateIndicatorWithAnimation(true)
        }
        self.addTarget(self, action: #selector(segmentTapped(_:)), for: .valueChanged)
    }
    
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
        super.draw(rect)
        var totalWidth: CGFloat = 0
        for segment in self.segments {
            let index = self.segments.index(of: segment)!
            let width = self.getWidthForSegmentAt(index)
            var segmentRect = segment.frame
            segmentRect.origin.x = totalWidth
            segmentRect.size.width = width + tabExtraWidth
            segment.frame = segmentRect
            totalWidth = totalWidth + segmentRect.size.width
        }
        
        tabExtraWidth = 0
        var newRect = rect
        newRect.size.width = totalWidth
        self.frame = newRect
        self.syncImageTintColor()
        
        DispatchQueue.main.async {
            self.indicatorMinX = self.getMinXForSegmentAt(self.selectedSegmentIndex)
            self.indicatorWidth = self.getWidthForSegmentAt(self.selectedSegmentIndex)
            self.updateIndicatorWithAnimation(true)
        }
     }
    
    override func didChangeValue(forKey key: String) {
        if key == "selectedSegmentIndex" {
            self.syncImageTintColor()
        }
    }
    
    override func setTitleTextAttributes(_ attributes: [AnyHashable : Any]?, for state: UIControlState) {
        super.setTitleTextAttributes(attributes, for: state)
        
        if state == .normal {
            self.setImageNormalColor(attributes![NSAttributedStringKey.foregroundColor] as! UIColor)
        } else if state == .selected {
            self.setImageSelectedColor(attributes![NSAttributedStringKey.foregroundColor] as! UIColor)
        }
    }
    
    func setImageNormalColor(_ color: UIColor) {
        imageNormalColor = color
        self.syncImageTintColor()
    }
    
    func setImageSelectedColor(_ color: UIColor) {
        imageSelectedColor = color
        self.syncImageTintColor()
    }
    
    fileprivate func syncImageTintColor() {
        for segment in self.segments {
            for subview in segment.subviews {
                if subview is UIImageView {
                    if self.segments.index(of: segment) == self.selectedSegmentIndex {
                        subview.tintColor = imageSelectedColor
                    } else {
                        subview.tintColor = imageNormalColor
                    }
                }
            }
        }
    }
    
    // MARK: - Properties
    
    func getSelectedSegment() -> UIView {
        return self.segments[self.selectedSegmentIndex]
    }
    
    func getMinXForSegmentAt(_ index: Int) -> CGFloat {
        return self.segments[index].frame.minX
    }
    
    func getWidthForSegmentAt(_ index: Int) -> CGFloat {
        return self.segments[index].frame.width
    }
    
    // MARK: - Actions
    @objc
    fileprivate func segmentTapped(_ segment: UISegmentedControl) {
        self.indicatorMinX = self.getMinXForSegmentAt(self.selectedSegmentIndex)
        self.indicatorWidth = self.getWidthForSegmentAt(self.selectedSegmentIndex)
        self.updateIndicatorWithAnimation(true)
    }
    
    fileprivate func updateIndicatorWithAnimation(_ animation: Bool) {
        var indicatorY:CGFloat = 0.0
        indicatorY = self.frame.height - self.indicatorHeight
        UIView.animate(withDuration: animation ? 0.3 : 0) {
            
            var rect = self.indicator.frame
            rect.origin.x = self.indicatorMinX
            rect.origin.y = indicatorY
            rect.size.width = self.indicatorWidth
            rect.size.height = self.indicatorHeight
            self.indicator.frame = rect
        }
    }
}
