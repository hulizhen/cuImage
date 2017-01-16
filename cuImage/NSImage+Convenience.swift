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
     Compress image by specified factor.
     
     - parameters:
        - factor: Range from 0 to 1, where 0 is the highest compression(lowest size, worst quality).
     
     - returns: Compressed image if succeeded, otherwise original image.
     */
    func compression(by factor: Float) -> NSImage {
        var image = self
        if let tiffRepresentation = self.tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiffRepresentation),
            let data = bitmap.representation(using: .JPEG, properties: [NSImageCompressionFactor: factor]) {
            image = NSImage(data: data) ?? image
        }
        return image
    }

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
