//
//  URL+Convenience.swift
//  cuImage
//
//  Created by Lizhen Hu on 12/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import ImageIO
import CoreServices

extension URL {
    /**
     Get image file extension if it is an image file.
     
     - note: The examination does not include PDF file.
     
     - returns: Image file extension if it is an image file, nil if is not.
     */
    func imageFileExtension() -> String? {
        let options: [String: Any?] = [kCGImageSourceShouldCache as String: false]
        
        if let source = CGImageSourceCreateWithURL(self as CFURL, options as CFDictionary),
            let uti = CGImageSourceGetType(source),
            !UTTypeConformsTo(uti, kUTTypePDF),
            UTTypeConformsTo(uti, kUTTypeImage) == true {
            return (uti as String).components(separatedBy: ".").last
        } else {
            return nil
        }
    }
    
    /**
     Determine whether the URL conforms to the specified UTI type.
     
     - parameters:
        - type: the uniform type identifier against which to test conformance.
     
     - returns: True if the URL conforms to the UTI type, false if not.
     */
    func conformsToUTI(type: CFString) -> Bool {
        let pathExtension = self.pathExtension as CFString
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, nil)
        if let uti = uti?.takeRetainedValue() {
            return UTTypeConformsTo(uti, type)
        } else {
            return false
        }
    }
}
