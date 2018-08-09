//
//  NetworkConnectionHandler.swift
//  ObserverPattern
//
//  Created by Bao Nguyen on 8/8/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class NetworkConnectionHandler: Observer {
    weak var view: UIView?
    
    init(view: UIView) {
        self.view = view
        super.init(notification: .networkConnection)
    }
    
    override func handleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let statusValue = userInfo[StatusKey.networkStatusKey.rawValue] as? String {
            
            print("Notification \(notification.name) received; status = \(statusValue)")
            if statusValue == NetworkConnectionStatus.connected.rawValue {
                view?.backgroundColor = .green
            } else {
                view?.backgroundColor = .red
            }
        }
    }
    
}
