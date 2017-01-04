//
//  HostsPreferences.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class HostsPreferences: NSObject {
    struct Key {
        static let currentHost = "currentHost"
        static let qiniuHost = "qiniuHost"
        
        private init() {}
    }
    
    static let shared = HostsPreferences()
    fileprivate let defaults = UserDefaults.standard
    private let defaultPreferences: [String: Any] = [Key.currentHost: SupportedHost.qiniu.rawValue]
    
    private override init() {
        super.init()
        
        defaults.register(defaults: defaultPreferences)
    }
}

// All preferences for general.
extension HostsPreferences {
    var currentHost: String {
        get { return defaults.value(forKey: Key.currentHost) as! String }
        set { defaults.set(newValue, forKey: Key.currentHost) }
    }

    var qiniuHost: QiniuHostPreferences {
        get { return defaults.value(forKey: Key.qiniuHost) as! QiniuHostPreferences }
        set { defaults.set(newValue, forKey: Key.qiniuHost) }
    }
}

class QiniuHostPreferences: NSObject {
    var accessKey: String?
    var secretKey: String?
    var domain: String?
    var bucket: String?
}
