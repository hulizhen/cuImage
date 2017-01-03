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
    
    fileprivate var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private let defaultPreferences: [String: Any] = [#keyPath(launchAtLogin): false,
                                                     #keyPath(keepWindowsOnTop): true]
    
    private override init() {
        super.init()
        
        defaults.register(defaults: defaultPreferences)
        
        defaults.addObserver(self, forKeyPath: #keyPath(launchAtLogin), options: [.new], context: nil)
        defaults.addObserver(self, forKeyPath: #keyPath(keepWindowsOnTop), options: [.new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    }
}

extension GeneralPreferences {
    var launchAtLogin: Bool {
        get { return defaults.bool(forKey: #keyPath(launchAtLogin)) }
        set { defaults.set(newValue, forKey: #keyPath(launchAtLogin)) }
    }
    
    var keepWindowsOnTop: Bool {
        get { return defaults.bool(forKey: #keyPath(keepWindowsOnTop)) }
        set { defaults.set(newValue, forKey: #keyPath(keepWindowsOnTop)) }
    }
}
