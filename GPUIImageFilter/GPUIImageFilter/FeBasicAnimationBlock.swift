//
//  FeBasicAnimationBlock.swift
//  GPUIImageFilter
//
//  Created by Bao Nguyen on 8/22/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import QuartzCore

class FeBasicAnimationBlock: NSObject, CAAnimationDelegate {
    
    typealias FeBasicAnimationDidStartBlock = (() -> Void)
    typealias FeBasicAnimationDidStopBlock = (() -> Void)
    
    var blockDidStart: FeBasicAnimationDidStopBlock?
    var blockDidStop: FeBasicAnimationDidStopBlock?
    
    func animationDidStart(_ anim: CAAnimation) {
        blockDidStart?()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        blockDidStop?()
    }
}
