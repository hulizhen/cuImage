//
//  MASShortcut+Convenience.swift
//  cuImage
//
//  Created by Lizhen Hu on 08/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import MASShortcut

extension MASShortcut {
    convenience init(key: Int, modifiers: [NSEvent.ModifierFlags] = []) {
        let flags = modifiers.reduce(0) { $0 | $1.rawValue }
        
        self.init(keyCode: UInt(key), modifierFlags: flags)
    }
    
    func data() -> Data {
        let bindingOptions = MASShortcutBinder.shared().bindingOptions!
        let transformer = bindingOptions[NSBindingOption.valueTransformer] as! ValueTransformer
        return transformer.reverseTransformedValue(self) as! Data
    }
}
