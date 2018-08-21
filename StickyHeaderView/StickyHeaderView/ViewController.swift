//
//  ViewController.swift
//  StickyHeaderView
//
//  Created by Bao Nguyen on 8/20/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var headerView: CustomHeaderView!
    fileprivate var headerHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpHeader()
        setUpTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let inputs = ["In-Queue", "Table A1", "Table A01", "Table A2", "Table A10", "Table A1-1", "Table A1.1"]
        
        let results = inputs.sorted {
            
            let firstStringNumber = $0.components(separatedBy: CharacterSet.decimalDigits.inverted).last!
            let secondStringNumber = $1.components(separatedBy: CharacterSet.decimalDigits.inverted).last!
            
            let firstIndexEnd = $0.index($0.endIndex, offsetBy: -firstStringNumber.count)
            let firstStringWithOutLatestNumber = String($0[..<firstIndexEnd])
            let secondIndexEnd = $1.index($1.endIndex, offsetBy: -secondStringNumber.count)
            let secondStringWithoutLatestNumber = String($1[..<secondIndexEnd])
            print(firstStringWithOutLatestNumber, secondStringWithoutLatestNumber)
            
            let compareResult = firstStringWithOutLatestNumber.compare(secondStringWithoutLatestNumber)
            if compareResult == .orderedSame {
                
                let firstNumber = Int(firstStringNumber)!
                let secondNumber = Int(secondStringNumber)!
                if firstNumber == secondNumber {
                    return firstStringNumber.compare(secondStringNumber) == .orderedAscending
                }
                return firstNumber > secondNumber
            }
            return compareResult == .orderedAscending
        }
        print(results)
    }
    
    private func setUpHeader() {
        headerView = CustomHeaderView(frame: .zero, title: "Articles")
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)
        
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: 150)
        headerHeightConstraint.isActive = true
        
        let constraints = [
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setUpTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource =  self
        tableView.delegate = self
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Article \(indexPath.row)"
        return cell
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            
            headerHeightConstraint.constant += abs(scrollView.contentOffset.y)
            headerView.incrementColorAlpha(headerHeightConstraint.constant)
            headerView.incrementArticleAlpha(headerHeightConstraint.constant)
        } else if scrollView.contentOffset.y > 0 && headerHeightConstraint.constant >= 65 {
            
            headerHeightConstraint.constant = headerHeightConstraint.constant - scrollView.contentOffset.y / 100
            headerView.decrementColorAlpha(scrollView.contentOffset.y)
            headerView.decrementArticleAlpha(self.headerHeightConstraint.constant)
            if headerHeightConstraint.constant < 65 {
                headerHeightConstraint.constant = 65
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if headerHeightConstraint.constant > 150 {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if headerHeightConstraint.constant > 150 {
            animateHeader()
        }
    }
    
    fileprivate func animateHeader() {
        headerHeightConstraint.constant = 150
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    
}
