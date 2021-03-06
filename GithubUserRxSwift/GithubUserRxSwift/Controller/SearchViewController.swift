//
//  SearchViewController.swift
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
import RxOptional

class SearchViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    var prodiver: MoyaProvider<GitHub>!
    var latestRepositoryName: Observable<String> {
        return searchBar
            .rx.text
            .filterNil()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    var issueTrackerModel: IssueTrackerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }
    
    fileprivate func setupRx() {
        self.prodiver = MoyaProvider()
        self.issueTrackerModel = IssueTrackerModel(provider: self.prodiver, repositoryName: self.latestRepositoryName)
        
        self.issueTrackerModel
            .trackIssues()
            .bind (to: self.tableView.rx.items) { tableView, row, item in
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = item.title
                return cell
            }
            .disposed(by: disposeBag)
        
        self.tableView
            .rx.itemSelected
            .subscribe(onNext: { _ in
                if self.searchBar.isFirstResponder {
                    self.view.endEditing(true)
                }
            })
            .disposed(by: disposeBag)
    }
}

//extension SearchViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        return cell
//    }
//}
//
//extension SearchViewController: UITableViewDelegate {
//    
//}
