//
//  MultiInputViewModel.swift
//  RX
//
//  Created by Bao Nguyen on 8/22/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MultiInputViewModel {
    var firstVariable = Variable<String>("")
    var secondVariable = Variable<String>("")
    
    var firstObservable: Observable<String> {
        return firstVariable.asObservable()
    }
    var secondObserable: Observable<String> {
        return secondVariable.asObservable()
    }
    var firstSecondObserable: Observable<String> {
        return Observable.combineLatest(firstVariable.asObservable(), secondVariable.asObservable()) { first, second in
            return "\(first) \(second)"
        }
    }
}
