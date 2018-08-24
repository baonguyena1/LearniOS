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
    
    fileprivate var provider: MoyaProvider<GitHub>!
    fileprivate let disposeBag = DisposeBag()
    fileprivate var userProfileViewModel: UserProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRx()
    }
    
    fileprivate func setupRx() {
        let username = "baonguyena1"
        self.provider = MoyaProvider<GitHub>()
        self.userProfileViewModel = UserProfileViewModel(provider: self.provider, username: username)
        
        self.userProfileViewModel
            .getUser()
            .subscribe { (userEvent) in
                print(userEvent)
//                guard let `self` = self else { return }
                if let user = userEvent.element as? User {
                    print(user.avatarUrl, user.name)
                }
            }
            .disposed(by: disposeBag)
    }
}
