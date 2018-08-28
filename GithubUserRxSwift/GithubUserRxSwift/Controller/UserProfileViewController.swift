//
//  UserProfileViewController.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MBProgressHUD

class UserProfileViewController: UIViewController, Storyboarded {
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var userProfileViewModel: UserProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRx()
    }
    
    fileprivate func setupRx() {
        let username = "baonguyena1"
        self.userProfileViewModel = UserProfileViewModel()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        self.userProfileViewModel
            .getUser(username: username)
            .subscribe(onNext: { (user) in
                print(user.login, user.avatarUrl, user.id)
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: {
                
            }, onDisposed: {
                MBProgressHUD.hide(for: self.view, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
