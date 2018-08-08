//
//  BrowserEngine.swift
//  NetService
//
//  Created by Bao Nguyen on 8/2/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class BrowserEngine: NSObject {
    
//    fileprivate let serviceType = "_ipp._tcp."
    fileprivate let serviceType = "_http._tcp."
    
    fileprivate var serviceBrowser: NetServiceBrowser?
    fileprivate var services: [NetService] = [NetService]()
    fileprivate var addressed: [NSObject: URL] = [NSObject: URL]()
    
    fileprivate var browsingTimer: Timer?
    fileprivate var emergencyPrimaryAddress: URL?
    
    static let shared: BrowserEngine = BrowserEngine()
    
    override init() {
        super.init()
        Logger.log("")
        serviceBrowser = nil
        browsingTimer = nil
        emergencyPrimaryAddress = nil
    }
    
    func startSearchService() {
        Logger.log("")
        if browsingTimer != nil {
            stopBrowserTimer()
            stopBrowsing()
            clearServices()
        }
        browsingTimer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(startBrowsing), userInfo: nil, repeats: true)
        browsingTimer?.fire()
    }
    
    func stopSearchService() {
        Logger.log("")
        stopBrowserTimer()
        stopBrowsing()
        clearServices()
    }
    
    fileprivate func stopBrowsing() {
        Logger.log("")
        if let serviceBrowser = serviceBrowser {
            serviceBrowser.stop()
            serviceBrowser.delegate = nil
            serviceBrowser.remove(from: .current, forMode: .default)
            self.serviceBrowser = nil
        }
    }
    
    @objc fileprivate func startBrowsing() {
        Logger.log("")
        if serviceBrowser != nil {
            return
        }
        serviceBrowser = NetServiceBrowser()
        serviceBrowser?.includesPeerToPeer = true
        serviceBrowser?.delegate = self
        serviceBrowser?.searchForServices(ofType: serviceType, inDomain: "")
        serviceBrowser?.schedule(in: .current, forMode: .default)
    }
    
    fileprivate func clearServices() {
        Logger.log("")
        services.forEach {
            $0.stopMonitoring()
            $0.delegate = nil
        }
        services.removeAll()
        addressed.removeAll()
    }
    
    fileprivate func stopBrowserTimer() {
        Logger.log("")
        browsingTimer?.invalidate()
        browsingTimer = nil
    }
}

extension BrowserEngine: NetServiceBrowserDelegate {
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {
        Logger.log("")
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        Logger.log("")
        addNetService(service)
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        Logger.log(errorDict)
        stopBrowsing()
        clearServices()
        
        startBrowsing()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        Logger.log("")
        removeNetService(service)
    }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {
        Logger.log("")
        stopBrowsing()
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFindDomain domainString: String, moreComing: Bool) {
        Logger.log("\(domainString), \(moreComing)")
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemoveDomain domainString: String, moreComing: Bool) {
        Logger.log("\(domainString), \(moreComing)")
    }
    
    // MARK: - Utility
    fileprivate func addNetService(_ service: NetService) {
        Logger.log("")
        let currentNetServices = Set(services)
        guard !currentNetServices.contains(service) else {
            return
        }
        services.append(service)
        service.delegate = self
        service.startMonitoring()
        service.schedule(in: .current, forMode: .default)
        service.resolve(withTimeout: 10)
    }
    
    fileprivate func removeNetService(_ service: NetService) {
        Logger.log("")
        service.delegate = nil
        service.stopMonitoring()
        service.remove(from: .current, forMode: .default)
        let filterServices = services.filter { $0 != service }
        services = filterServices
    }
}

extension BrowserEngine: NetServiceDelegate {
    func netServiceDidResolveAddress(_ sender: NetService) {
        Logger.log("")
        print(sender.hostName, sender.port)
    }

    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        Logger.log("")
        sender.delegate = nil
    }

    func netService(_ sender: NetService, didUpdateTXTRecord data: Data) {
        Logger.log("")
        let dict = NetService.dictionary(fromTXTRecord: data)
        print(dict)
    }
}
