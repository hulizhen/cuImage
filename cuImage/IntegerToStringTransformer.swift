//
//  IntegerToStringTransformer.swift
//  cuImage
//
//  Created by Lizhen Hu on 20/02/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

class IntegerToStringTransformer: ValueTransformer {
    let name = NSValueTransformerName(rawValue: "IntegerToStringTransformer")
    
    override static func transformedValueClass() -> Swift.AnyClass {
        return NSString.self
    }
    
    override static func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let value = value as? NSNumber else { return nil }
        return value.stringValue
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let value = value as? NSString else { return nil }
        return value.integerValue
    }
}
