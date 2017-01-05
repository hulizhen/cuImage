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
    struct Key {
        static let uploadImageShortcut = "uploadImageShortcut"
    }
    
    static let shared = ShortcutsPreferences()

    private override init() {
        super.init()
        
        registerShortcuts()
    }
    
    private func registerShortcuts() {
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: Key.uploadImageShortcut,
                                                toAction: uploadImageOnPasteboard)
    }
    
    private func uploadImageOnPasteboard() {
        UploadController.shared.uploadImageOnPasteboard()
    }
}
