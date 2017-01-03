//
//  PreferenceManager.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class PreferenceManager: NSObject {
    static let shared = PreferenceManager()
    
    let generalPreferences = GeneralPreferences.shared
    let shortcutsPreferences = ShortcutsPreferences.shared
    let hostsPreferences = HostsPreferences.shared
}
