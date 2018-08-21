//
//  UserViewController.swift
//  RX
//
//  Created by Bao Nguyen on 8/21/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserViewController: UIViewController {
    
    let requestStream: Observable<String> = Observable.just("https://api.github.com/users")
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        requestStream
            .subscribe(onNext: { (url) in
            print(url)
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
