//
//  LocationChangehandler.swift
//  ObserverPattern
//
//  Created by Bao Nguyen on 8/8/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class LocationChangeHandler: Observer {
    
    weak var locationLabel: UILabel?
    
    init(locationLabel: UILabel) {
        self.locationLabel = locationLabel
        super.init(notification: .locationChange)
    }
    
    override func handleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let locationChange = userInfo[LocationKey.locationChangeKey.rawValue] as? String {
            
            print("Notification \(notification.name) received; location = \(locationChange)")
            locationLabel?.text = "\(locationChange)"
        }
    }
    
    
}
