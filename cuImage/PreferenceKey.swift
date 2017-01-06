//
//  PreferenceKey.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation

class PreferenceKeys: RawRepresentable, Hashable {
    let rawValue: String
    
    required init!(rawValue: String) {
        self.rawValue = rawValue
    }
    
    fileprivate convenience init(_ key: String) {
        self.init(rawValue: key)
    }
    
    var hashValue: Int {
        return rawValue.hashValue
    }
}

final class PreferenceKey<T>: PreferenceKeys { }

/// The collection of all preference keys
extension PreferenceKeys {
    // General
    static let launchAtLogin = PreferenceKey<Bool>("launchAtLogin")
    static let keepWindowsOnTop = PreferenceKey<Bool>("keepWindowsOnTop")
    
    // Shortcuts
    static let uploadImageShortcut = PreferenceKey<Any>("uploadImageShortcut")
    
    // Hosts
    static let currentHost = PreferenceKey<String>("currentHost")
    static let qiniuHostInfo = PreferenceKey<[String: Any]>("qiniuHostInfo")
}

/// The collection of all default preference value
let defaultPreferences: [PreferenceKeys: Any] = [
    // General
    .launchAtLogin: false,
    .keepWindowsOnTop: true,
    
    // Shortcuts
    // No default preferences, because shortcuts are managed by MASShortcut.
    
    // Hosts
    .currentHost: SupportedHost.qiniu.rawValue,
    .qiniuHostInfo: QiniuHostInfo().dictionary(),
]
