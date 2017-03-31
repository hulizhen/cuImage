//
//  NSImage+Convenience.swift
//  cuImage
//
//  Created by Lizhen Hu on 14/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

extension NSImage {
    /// Get JPEG representation image data with specified compression quality.
    ///
    /// - Parameter quality: The value is a float between 0.0 and 1.0,
    ///                     with 1.0 resulting in no compression and
    ///                     0.0 resulting in the maximum compression possible.
    /// - Returns: JPEG representation image data with specified compression quality.
    func JPEGRepresentation(with quality: Float = 1.0) -> Data? {
        if let tiffRepresentation = self.tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiffRepresentation),
            let data = bitmap.representation(using: .JPEG, properties: [NSImageCompressionFactor: quality]) {
            return data
        }
        return nil
    }

    /// Generate thumbnail of the image.
    ///
    /// - Parameter maxSize: The maximum width and height in pixels of a thumbnail.
    /// - Returns: Thumbnail of the image.
    func thumbnail(maxSize: Float) -> NSImage? {
        var options: [String: Any?] = [kCGImageSourceShouldCache as String: false]

        var thumbnail: NSImage?
        if let source = CGImageSourceCreateWithData(tiffRepresentation! as CFData, options as CFDictionary) {
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
