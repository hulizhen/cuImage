//
//  HostsPreferences.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

protocol HostsPreferencesSaving {
    func saveHostPreferences();
}

class HostsPreferences: NSObject {
    struct Key {
        static let currentHost = "currentHost"
        static let qiniuHost = "qiniuHost"
        
        private init() {}
    }
    
    static let shared = HostsPreferences()
    fileprivate let defaults = UserDefaults.standard
    private let defaultPreferences: [String: Any] = [Key.currentHost: SupportedHost.qiniu.rawValue,
                                                     Key.qiniuHost: NSKeyedArchiver.archivedData(withRootObject: QiniuHostPreferences())]
    
    private override init() {
        super.init()
        
        defaults.register(defaults: defaultPreferences)
    }
}

// All preferences for general.
extension HostsPreferences {
    var currentHost: String {
        get {
            return defaults.value(forKey: Key.currentHost) as! String
        }
        set {
            defaults.set(newValue, forKey: Key.currentHost)
        }
    }

    var qiniuHost: QiniuHostPreferences {
        get {
            let data = defaults.value(forKey: Key.qiniuHost) as! Data
            return NSKeyedUnarchiver.unarchiveObject(with: data) as! QiniuHostPreferences
        }
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
            defaults.set(data, forKey: Key.qiniuHost)
        }
    }
}
