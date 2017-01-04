//
//  HostsPreferences.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class HostsPreferences: NSObject {
    static let shared = HostsPreferences()
    
    struct Key {
        static let currentHost = "currentHost"
        static let qiniuHost = "qiniuHost"
        
        private init() {}
    }
    
    fileprivate var defaults: UserDefaults {
        return UserDefaults.standard
    }

    private let defaultPreferences: [String: Any] = [Key.currentHost: SupportedHost.qiniu.rawValue]
    
    private override init() {
        super.init()
        
        defaults.register(defaults: defaultPreferences)
    }
}

extension HostsPreferences {
    var currentHost: SupportedHost {
        get { return SupportedHost(rawValue: defaults.value(forKey: Key.currentHost) as! String)! }
        set {
            defaults.set(newValue, forKey: Key.currentHost)
        }
    }

    var qiniuHost: QiniuHostPreferences? {
        get { return defaults.value(forKey: Key.qiniuHost) as? QiniuHostPreferences }
        set {
            defaults.set(newValue, forKey: Key.qiniuHost)
        }
    }
}

class QiniuHostPreferences: NSObject {
    var accessKey: String?
    var secretKey: String?
    var domain: String?
    var bucket: String?
}
