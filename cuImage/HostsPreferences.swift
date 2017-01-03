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
    
    fileprivate var defaults: UserDefaults {
        return UserDefaults.standard
    }
    
    private override init() {
        super.init()
    }
}

extension HostsPreferences {
    var qiniuHostPreferences: QiniuHostPreferences {
        get { return defaults.value(forKey: #keyPath(qiniuHostPreferences)) as! QiniuHostPreferences }
        set { defaults.set(qiniuHostPreferences, forKey: #keyPath(qiniuHostPreferences)) }
    }
}
