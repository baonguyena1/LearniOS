//
//  CircleViewModel.swift
//  RX
//
//  Created by Bao Nguyen on 8/23/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ChameleonFramework

class CircleViewModel {
    
    var centerVariable = Variable<CGPoint?>(.zero)
    var backgroundColorObservable: Observable<UIColor> {
        return centerVariable.asObservable().map({ (center) -> UIColor in
            guard let center = center else { return UIColor.flatten(.black)() }
            
            let red: CGFloat = CGFloat((Int((center.x + center.y)) % 255)) / 255.0 // We just manipulate red, but you can do w/e
            let green: CGFloat = 0.0
            let blue: CGFloat = 0.0
            
            return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        })
    }
}
