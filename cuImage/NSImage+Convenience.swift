//
//  NSImage+Convenience.swift
//  cuImage
//
//  Created by HuLizhen on 14/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension NSImage {
    /**
     Generate thumbnail of the image.
     */
    func thumbnail(maxSize: Float) -> NSImage? {
        var options: [String: Any?] = [kCGImageSourceShouldCache as String: false]

        var thumbnail: NSImage?
        if let source = CGImageSourceCreateWithData(tiffRepresentation as! CFData, options as CFDictionary) {
            options = [kCGImageSourceShouldCache as String: false,
                       kCGImageSourceThumbnailMaxPixelSize as String: maxSize,
                       kCGImageSourceCreateThumbnailFromImageAlways as String: true]
            
            if let image = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) {
                thumbnail = NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height))
            }
        }
        return thumbnail
    }
}
