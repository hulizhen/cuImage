//
//  NSImage+Compression.swift
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
}
