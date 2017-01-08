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
        // Set the value transformer for MASShortcut.
        let transformer = ValueTransformer(forName: NSValueTransformerName.keyedUnarchiveFromDataTransformerName)!
        MASShortcutBinder.shared().bindingOptions = [NSValueTransformerBindingOption: transformer]
        
        registerDefaultShortcuts()
        bindShortcuts()
    }
    
    private func registerDefaultShortcuts() {
        let defaultValues: [String: Any] = defaultShortcuts.reduce([:]) {
            var dictionary = $0
            dictionary[$1.key.rawValue] = $1.value
            return dictionary
        }
//        MASShortcutBinder.shared().registerDefaultShortcuts(defaultValues)
        let defaults = UserDefaults.standard
        defaults.register(defaults: defaultValues)
    }
    
    private func bindShortcuts() {
        MASShortcutBinder.shared().bindShortcut(withDefaultsKey: PreferenceKeys.uploadImageShortcut.rawValue,
                                                toAction: uploadImageOnPasteboard)
    }
    
    private func uploadImageOnPasteboard() {
        UploadController.shared.uploadImageOnPasteboard()
    }
}

extension PreferenceManager {
    subscript(key: PreferenceKey<MASShortcut>) -> MASShortcut {
        // Read-only because the shortcuts is managed by MASShortcut.
        get {
            let data = defaults.data(forKey: key.rawValue)
            let bindingOptions = MASShortcutBinder.shared().bindingOptions!
            let transformer = bindingOptions[NSValueTransformerBindingOption] as! ValueTransformer
            return transformer.transformedValue(data) as? MASShortcut ?? MASShortcut()
        }
    }
}

extension PreferenceKeys {
    static let uploadImageShortcut = PreferenceKey<MASShortcut>("uploadImageShortcut")
}

// The collection of all default shortcuts.
fileprivate let defaultShortcuts: [PreferenceKeys: Any] = [
    .uploadImageShortcut: MASShortcut(key: kVK_ANSI_U, modifiers: [.command, .shift]).data(),
]
