//
//  ShortcutsPreferences.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import MASShortcut

class ShortcutsPreferences: NSObject {
    static let shared = ShortcutsPreferences()
    
    struct ShortcutKey {
        static let uploadImageShortcut = "uploadImageShortcut"
    }
    
    private override init() {
        super.init()
        
        registerShortcuts()
    }
    
    private func registerShortcuts() {
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: ShortcutKey.uploadImageShortcut,
                                                toAction: uploadImageOnPasteboard)
    }
    
    private func uploadImageOnPasteboard() {
    }
}
