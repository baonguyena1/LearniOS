//
//  MVVMViewController.swift
//  RX
//
//  Created by Bao Nguyen on 8/22/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/**
 * 1. Mình sẽ quan sát bên ViewController (VC) có bao nhiêu thành phần input rồi qua bên ViewModel (VM) khai báo bấy nhiêu Variable, hoặc PublishSubject.
 * 2. VM sẽ nhận tín hiệu, data của Input từ VC (như là hit button, edit textfield v..v)
 * 3. VM sau khi nhận được tín hiệu để xử lý data đó theo requirement rồi send back data đến VC bằng cách phát ra các Observable tương ứng
 * 4. Output ở VC sẽ subscribe những Observable mà VM cung cấp
 **/

class MVVMViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    let inputViewModel = InputViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inputTextField
            .rx.text
            .map { $0 ?? "" }
            .bind(to: inputViewModel.inputTextField)
            .disposed(by: disposeBag)
        
        inputViewModel.inputTextObservable
            .subscribe(onNext: { [unowned self] (text) in
                self.outputLabel.text = text
            })
            .disposed(by: disposeBag)
    }

}
