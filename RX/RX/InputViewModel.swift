//
//  InputViewModel.swift
//  RX
//
//  Created by Bao Nguyen on 8/22/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class InputViewModel {
    var inputTextField = Variable<String>("")
    
    var inputTextObservable: Observable<String> {
        return inputTextField.asObservable()
    }
}
