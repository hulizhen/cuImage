//
//  NSBitmapImageFileType+String.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension NSBitmapImageFileType {
    var string: String {
        switch self {
        case .TIFF:     return "tiff"
        case .BMP:      return "bmp"
        case .GIF:      return "gif"
        case .PNG:      return "png"
        case .JPEG:     return "jpg"
        case .JPEG2000: return "jp2"
        }
    }
}
