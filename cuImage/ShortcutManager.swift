//
//  ShortcutManager.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation
import MASShortcut

class ShortcutManager {
    static let shared = ShortcutManager()
    
    private init() {
        registerShortcuts()
    }
    
    private func registerShortcuts() {
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: PreferenceKeys.uploadImageShortcut.rawValue,
                                                toAction: uploadImageOnPasteboard)
    }
    
    private func uploadImageOnPasteboard() {
        UploadController.shared.uploadImageOnPasteboard()
    }
}
