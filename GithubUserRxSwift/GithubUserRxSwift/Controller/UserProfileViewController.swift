//
//  UserProfileViewController.swift
//  GithubUserRxSwift
//
//  Created by Bao Nguyen on 8/24/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit
import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

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
        
        self.userProfileViewModel
            .getUser(username: username)
            .subscribe(onNext: { (user) in
                print(user.login, user.avatarUrl, user.id, user.name)
            }, onError: { (error) in
                print(error.localizedDescription)
            }, onCompleted: {
                // Hide indicator
            })
            .disposed(by: disposeBag)
    }
}
