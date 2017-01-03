//
//  Host.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

protocol Host: class {
    func uploadImage(_ image: NSImage, named name: String, in type: NSBitmapImageFileType);
}

protocol HostDelegate: class {
    func host(_ host: Host, isUploadingImageWithPercent percent: Float);
    func host(_ host: Host, didUploadImageWithURLString urlString: String);
}
