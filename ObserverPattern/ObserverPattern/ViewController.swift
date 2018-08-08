//
//  ViewController.swift
//  ObserverPattern
//
//  Created by Bao Nguyen on 8/8/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ObservedProtocol {
    
    @IBOutlet weak var networkSwitch: UISwitch!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var statusKey: StatusKey = StatusKey.networkStatusKey
    
    var notification: Notification.Name = .networkConnection
    
    var networkConnectionHandler0: NetworkConnectionHandler?
    var networkConnectionHandler1: NetworkConnectionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkConnectionHandler0 = NetworkConnectionHandler(view: topView)
        networkConnectionHandler1 = NetworkConnectionHandler(view: bottomView)
        
        networkSwitchChange(networkSwitch)
    }

    @IBAction func networkSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            notifyObservers(about: NetworkConnectionStatus.connected.rawValue)
        } else {
            notifyObservers(about: NetworkConnectionStatus.disconnected.rawValue)
        }
    }
}

