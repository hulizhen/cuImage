//
//  UploadManager.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

final class UploadManager {
    static let shared = UploadManager()
    
    private var host: Host?
    
    private init() {
        host = QiniuHost(delegate: self)
    }
    
    /// Upload the image on pasteboard.
    /// - Parameter pasteboard: the pasteboard on which the image is, general pasteboard by default.
    func uploadImageOnPasteboard(_ pasteboard: NSPasteboard = NSPasteboard.general()) {
        guard let host = host else { return }
        guard let types = pasteboard.types else { return }
        guard let objects = pasteboard.readObjects(forClasses: [NSURL.self, NSImage.self], options: nil) else { return }
        
        // Read the file if it is an image file, otherwise upload the image data.
        if types.contains(kUTTypeFileURL as String),
            let fileURL = objects.first as? URL {
            if fileURL.conformsToUTI(type: kUTTypeImage) {
                host.uploadImageFile(fileURL)
            }
        } else if types.contains(kUTTypeImage as String),
            let image = objects.first as? NSImage {
            host.uploadImageData(image, named: "Screenshot", in: .PNG)
        }
    }
}

extension UploadManager: HostDelegate {
    func host(_ host: Host, isUploadingImageWithPercent percent: Float) {
        print("Percent: \(percent)")
    }
    
    func host(_ host: Host, didUploadImageWithURLString urlString: String) {
        print("URL String: \(urlString)")
        
        let pasteBoard = NSPasteboard.general()
        pasteBoard.declareTypes([NSPasteboardTypeString], owner: nil)
        assert(pasteBoard.setString(urlString, forType: NSPasteboardTypeString),
               "Failed to write object to the general pasteboard")
    }
}
