//
//  GeneralPreferences.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class GeneralPreferences: NSObject {
    static let shared = GeneralPreferences()
    
    struct Key {
        static let launchAtLogin = "launchAtLogin"
        static let keepWindowsOnTop = "keepWindowsOnTop"
        
        private init() {}
    }
    
    fileprivate var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private let defaultPreferences: [String: Any] = [Key.launchAtLogin: false,
                                                     Key.keepWindowsOnTop: true]
    
    private override init() {
        super.init()
        
        defaults.register(defaults: defaultPreferences)
        
        defaults.addObserver(self, forKeyPath: Key.launchAtLogin, options: [.new], context: nil)
        defaults.addObserver(self, forKeyPath: Key.keepWindowsOnTop, options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    }
}

extension GeneralPreferences {
    var launchAtLogin: Bool {
        get { return defaults.bool(forKey: Key.launchAtLogin) }
        set { defaults.set(newValue, forKey: Key.launchAtLogin) }
    }
    
    var keepWindowsOnTop: Bool {
        get { return defaults.bool(forKey: Key.keepWindowsOnTop) }
        set { defaults.set(newValue, forKey: Key.keepWindowsOnTop) }
    }
}
