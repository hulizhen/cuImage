//
//  URL+UTI.swift
//  cuImage
//
//  Created by HuLizhen on 12/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension URL {
    /// Determine whether the URL is conformed to the specified UTI type.
    /// - Parameter type: the uniform type identifier against which to test conformance.
    func conformsToUTI(type: CFString) -> Bool {
        let fileExtension = self.pathExtension as CFString
        let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, nil)
        if let uti = uti?.takeRetainedValue() {
            return UTTypeConformsTo(uti, type)
        } else {
            return false
        }
    }
    
    /// Determine whether the URL is an image file URL.
    func isImageFileURL() -> Bool {
        if pathExtension == "", NSImage(contentsOf: self) != nil {
            // True if the url is an image file URL, even without a path extension.
            return true
        } else if conformsToUTI(type: kUTTypeImage) {
            // True if the url conforms to image UTI.
            return true
        } else {
            return false
        }
    }
}
