//
//  HostInfo.swift
//  cuImage
//
//  Created by Lizhen Hu on 13/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

class HostInfo: NSObject, NSCoding {
    override init() {
        super.init()
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
        
        for child in Mirror(reflecting: self).children {
            if let key = child.label {
                setValue(aDecoder.decodeObject(forKey: key), forKey: key)
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        for child in Mirror(reflecting: self).children {
            if let key = child.label {
                aCoder.encode(value(forKey: key), forKey: key)
            }
        }
    }
}
