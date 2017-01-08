//
//  ShortcutManager.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation
import MASShortcut
import Carbon.HIToolbox

class ShortcutManager {
    static let shared = ShortcutManager()
    
    private init() {
        registerDefaultShortcuts()
        bindShortcuts()
    }
    
    private func registerDefaultShortcuts() {
        let defaultValues: [String: Any] = defaultShortcuts.reduce([:]) {
            var dictionary = $0
            dictionary[$1.key.rawValue] = $1.value
            return dictionary
        }
        MASShortcutBinder.shared().registerDefaultShortcuts(defaultValues)
    }
    
    private func bindShortcuts() {
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: PreferenceKeys.uploadImageShortcut.rawValue,
                                                toAction: uploadImageOnPasteboard)
    }
    
    private func uploadImageOnPasteboard() {
        UploadController.shared.uploadImageOnPasteboard()
    }
}

extension PreferenceKeys {
    static let uploadImageShortcut = PreferenceKey<Any>("uploadImageShortcut")
}

// The collection of all default shortcuts.
fileprivate let defaultShortcuts: [PreferenceKeys: Any] = [
    .uploadImageShortcut: MASShortcut(key: kVK_ANSI_U, modifiers: [.command, .shift]),
]
