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
    static let locationChange = Notification.Name("locationChange")
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

enum LocationKey: String {
    case locationChangeKey
}

protocol ObserverProtocol {
    var notificationOfInterest: Notification.Name { get }
    func subscribe()
    func unsubscribe()
    func handleNotification(_ notification: Notification)
}

class Observer: ObserverProtocol {
    var notificationOfInterest: Notification.Name
    
    init(notification: Notification.Name) {
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
        handleNotification(notification)
    }
    
    func handleNotification(_ notification: Notification) {
        fatalError("ERROR: You must override the [handleNotification] method.")
    }
    
    deinit {
        print("Observer unsubscribing from notifications.")
        unsubscribe()
    }
    
}

protocol ObservedProtocol {
    func notifyObservers(about changeTo: [String: Any])
}

extension ObservedProtocol {
    
    func notifyObservers(about changeTo: [String: Any]) {
        NotificationCenter.default.post(name: notification, object: self, userInfo: changeTo)
    }
}
