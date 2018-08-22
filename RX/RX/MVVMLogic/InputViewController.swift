//
//  InputViewController.swift
//  RX
//
//  Created by Bao Nguyen on 8/22/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class InputViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    let multiInputViewModel = MultiInputViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstTextField
            .rx.text
            .map { $0 ?? "" }
            .bind(to: multiInputViewModel.firstVariable)
            .disposed(by: disposeBag)
        
        secondTextField
            .rx.text
            .map { $0 ?? "" }
            .bind(to: multiInputViewModel.secondVariable)
            .disposed(by: disposeBag)
        
        multiInputViewModel.firstSecondObserable
            .subscribe(onNext: { [unowned self] (text) in
                self.resultLabel.text = text
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
