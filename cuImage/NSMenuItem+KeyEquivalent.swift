//
//  NSMenuItem+KeyEquivalent.swift
//  cuImage
//
//  Created by Lizhen Hu on 08/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import MASShortcut

extension NSMenuItem {
    func setKeyEquivalent(withShortcut shortcut: MASShortcut) {
        keyEquivalent = shortcut.keyCodeStringForKeyEquivalent
        keyEquivalentModifierMask = NSEventModifierFlags(rawValue: shortcut.modifierFlags)
    }
}
