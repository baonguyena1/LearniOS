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
    @IBOutlet weak var locationLabel: UILabel!
    
    var locationUpdateTimer: Timer?
    
    var networkConnectionHandler0: NetworkConnectionHandler?
    var networkConnectionHandler1: NetworkConnectionHandler?
    var locationUpdateHandler: LocationChangeHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkConnectionHandler0 = NetworkConnectionHandler(view: topView)
        networkConnectionHandler1 = NetworkConnectionHandler(view: bottomView)
        locationUpdateHandler = LocationChangeHandler(locationLabel: locationLabel)
        
        networkSwitchChange(networkSwitch)
        locationUpdateTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(locationUpdateHandler(_:)), userInfo: nil, repeats: true)
        locationUpdateTimer?.fire()
    }
    
    @objc func locationUpdateHandler(_ timer: Timer) {
        let dateString = "\(Date())"
        let userInfo = [
            LocationKey.locationChangeKey.rawValue: dateString
        ]
        notifyObservers(about: userInfo)
    }

    @IBAction func networkSwitchChange(_ sender: UISwitch) {
        if sender.isOn {
            notifyObservers(about: [StatusKey.networkStatusKey.rawValue: NetworkConnectionStatus.connected.rawValue])
        } else {
            notifyObservers(about: [StatusKey.networkStatusKey.rawValue: NetworkConnectionStatus.disconnected.rawValue])
        }
    }
}

