//
//  HostInfo.swift
//  cuImage
//
//  Created by Lizhen Hu on 13/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

@objcMembers
class HostInfo: NSObject, NSCoding {
    var name = ""

    override init() {
        super.init()
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        
        forEachChildOfMirror(reflecting: self) { key in
            setValue(aDecoder.decodeObject(forKey: key), forKey: key)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        forEachChildOfMirror(reflecting: self) { key in
            aCoder.encode(value(forKey: key), forKey: key)
        }
    }
    
    private func forEachChildOfMirror(reflecting subject: Any, handler: (String) -> Void) {
        var mirror: Mirror? = Mirror(reflecting: subject)
        while mirror != nil {
            for child in mirror!.children {
                if let key = child.label {
                    handler(key)
                }
            }
            
            // Get super class's properties.
            mirror = mirror!.superclassMirror
        }
    }
}
