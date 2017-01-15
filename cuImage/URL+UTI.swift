//
//  URL+UTI.swift
//  cuImage
//
//  Created by HuLizhen on 12/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension URL {
    /**
     Determine whether the URL conforms to the specified UTI type.
     
     - parameters:
        - type: the uniform type identifier against which to test conformance.
     
     - returns: True if the URL conforms to the UTI type, false if not.
     */
    func conformsToUTI(type: CFString) -> Bool {
        let fileExtension = self.pathExtension as CFString
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)
        if let uti = uti?.takeRetainedValue() {
            return UTTypeConformsTo(uti, type)
        } else {
            return false
        }
    }
}
