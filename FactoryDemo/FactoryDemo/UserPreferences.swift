//
//  UserPreferences.swift
//  FactoryDemo
//
//  Created by Bao Nguyen on 8/7/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import Foundation

class UserPreferences {
    
    enum Preferences {
        
        enum UserCredentials: String {
            case passwordVisible
            case password
            case username
        }
        
        enum AppState: String {
            case appFirstRun
            case dateLastRun
            case currentVersion
        }
    }
    
    static let shared =  UserPreferences()
    
    private let userPreferences: UserDefaults
    
    private init() {
        userPreferences = UserDefaults.standard
    }
    
    func set(_ boolean: Bool, forKey key: String) {
        if key != "" {
            userPreferences.set(boolean, forKey: key)
            userPreferences.synchronize()
        }
    }
    
    func getBoolean(for key: String) -> Bool {
        if let _ = userPreferences.value(forKey: key) as! Bool? {
            return true
        } else {
            return false
        }
    }
    
    func isPasswordVisible() -> Bool {
        let isVisible = userPreferences.bool(forKey: Preferences.UserCredentials.passwordVisible.rawValue)
        return isVisible
    }
    
    func setPasswordVisibity(_ visible: Bool) {
        userPreferences.set(visible, forKey: Preferences.UserCredentials.passwordVisible.rawValue)
        userPreferences.synchronize()
    }
    
}
