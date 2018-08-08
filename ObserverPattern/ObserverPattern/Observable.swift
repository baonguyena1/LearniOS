//
//  Observable.swift
//  ObserverPattern
//
//  Created by Bao Nguyen on 8/8/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let networkConnection = Notification.Name("networkConnection")
}

enum NetworkConnectionStatus: String {
    case connected
    case disconnected
    case connecting
    case disconnecting
    case error
}

enum StatusKey: String {
    case networkStatusKey
}

protocol ObserverProtocol {
    
    var statusValue: String { get set }
    var statusKey: String { get }
    var notificationOfInterest: Notification.Name { get }
    func subscribe()
    func unsubscribe()
    func handleNotification()
}

class Observer: ObserverProtocol {
    
    var statusValue: String
    
    var statusKey: String
    
    var notificationOfInterest: Notification.Name
    
    init(statusKey: StatusKey, notification: Notification.Name) {
        self.statusValue = "N/A"
        self.statusKey = statusKey.rawValue
        self.notificationOfInterest = notification
        subscribe()
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(_:)), name: notificationOfInterest, object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: notificationOfInterest, object: nil)
    }
    
    @objc func receiveNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo[statusKey] as? String {
            
            statusValue = status
            handleNotification()
            print("Notification \(notification.name) received; status = \(statusValue)")
        }
    }
    
    func handleNotification() {
        fatalError("ERROR: You must override the [handleNotification] method.")
    }
    
    deinit {
        print("Observer unsubscribing from notifications.")
        unsubscribe()
    }
    
}

class NetworkConnectionHandler: Observer {
    var view: UIView
    
    init(view: UIView) {
        self.view = view
        super.init(statusKey: .networkStatusKey, notification: .networkConnection)
    }
    
    override func handleNotification() {
        if statusValue == NetworkConnectionStatus.connected.rawValue {
            view.backgroundColor = .green
        } else {
            view.backgroundColor = .red
        }
    }
    
}

protocol ObservedProtocol {
    var statusKey: StatusKey { get }
    var notification: Notification.Name { get }
    func notifyObservers(about changeTo: String)
}

extension ObservedProtocol {
    
    func notifyObservers(about changeTo: String) {
        NotificationCenter.default.post(name: notification, object: self, userInfo: [statusKey.rawValue: changeTo])
    }
}
