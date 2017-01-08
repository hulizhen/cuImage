//
//  MASShortcut+Convenience.swift
//  cuImage
//
//  Created by HuLizhen on 08/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import MASShortcut

extension MASShortcut {
    convenience init(key: Int, modifiers: [NSEventModifierFlags]) {
        let flags = modifiers.reduce(0) { $0 | $1.rawValue }
        
        self.init(keyCode: UInt(key), modifierFlags: flags)
    }
    
    func data() -> Data {
        let bindingOptions = MASShortcutBinder.shared().bindingOptions!
        let transformer = bindingOptions[NSValueTransformerBindingOption] as! ValueTransformer
        return transformer.reverseTransformedValue(self) as! Data
    }
}
