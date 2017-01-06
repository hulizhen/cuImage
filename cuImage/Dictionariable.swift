//
//  Dictionariable.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation

/// A type that can be converted to and from a dictionary.
protocol Dictionariable: class {
    init(dictionary: [String: Any])
    func dictionary() -> [String: Any]
}

// Default implementation for protocol Dictionariable.
extension Dictionariable where Self: NSObject {
    init(dictionary: [String: Any]) {
        self.init()
        
        for child in Mirror(reflecting: self).children {
            if let key = child.label {
                setValue(dictionary[key], forKey: key)
            }
        }
    }
    
    func dictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        
        for child in Mirror(reflecting: self).children {
            if let key = child.label {
                dictionary[key] = value(forKey: key)
            }
        }
        
        return dictionary
    }
}
