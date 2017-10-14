//
//  NSBitmapImageFileType+String.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

extension NSBitmapImageRep.FileType {
    var string: String {
        switch self {
        case .tiff:     return "tiff"
        case .bmp:      return "bmp"
        case .gif:      return "gif"
        case .png:      return "png"
        case .jpeg:     return "jpeg"
        case .jpeg2000: return "jp2"
        }
    }
}
