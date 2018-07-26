//
//  CourseViewController.swift
//  Learn
//
//  Created by Bao Nguyen on 7/16/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var infomationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var users: [User]! = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Service.shared.fetchUsers { [weak self] (result) in
            
            switch result {
            case .success(let jsonArray):
                let users = jsonArray.compactMap(User.init)
                self?.users = users
            case .fail(let error):
                self?.infomationLabel.text = error.description()
            }
        }
    }
    
    @IBAction func signinTapped(_ sender: UIButton) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let email = emailTextField.text
        let postData = [
            "username": username,
            "password": password,
            "email": email
        ]
        Service.shared.signin(postData as JSON) { [weak self] (result) in
            switch result {
            case .success(let userJson):
                let user = User(with: userJson)
                self?.users.append(user)
            case .fail(let error):
                self?.infomationLabel.text = error.description()
            }
        }
    }
    
}

extension UserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username
        cell.detailTextLabel?.text = user.id
        return cell
    }
}
