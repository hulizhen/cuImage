//
//  NSBitmapImageFileType+String.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

extension NSBitmapImageFileType {
    var string: String {
        switch self {
        case .TIFF:     return "tiff"
        case .BMP:      return "bmp"
        case .GIF:      return "gif"
        case .PNG:      return "png"
        case .JPEG:     return "jpeg"
        case .JPEG2000: return "jp2"
        }
    }
}
