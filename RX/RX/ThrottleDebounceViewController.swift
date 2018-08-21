//
//  ThrottleDebounceViewController.swift
//  RX
//
//  Created by Bao Nguyen on 8/21/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ThrottleDebounceViewController: UIViewController {

    @IBOutlet weak var throttleButton: UIButton!
    @IBOutlet weak var debounceButton: UIButton!
    @IBOutlet weak var throttleTextView: UITextView!
    @IBOutlet weak var debounceTextView: UITextView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        throttleButton
            .rx.tap
            .asDriver()
            .throttle(2)
            .drive(onNext: { [weak self](_) in
            
                guard let `self` = self else { return }
                self.throttleTextView.text = self.throttleTextView.text + "\nTaps"
                
        }).disposed(by: disposeBag)
        
        debounceButton
            .rx.tap
            .asDriver()
            .debounce(2)
            .drive(onNext: { [weak self](_) in
                
                guard let `self` = self else { return }
                self.debounceTextView.text = self.debounceTextView.text + "\nTaps"
                
            }).disposed(by: disposeBag)
    }

}
