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
        let classes: [AnyClass] = [NSURL.self, NSImage.self]
        guard let objects = pasteboard.readObjects(forClasses: classes, options: nil) else { return }
        
        if let fileURL = objects.first as? URL {
            // Upload the file if it is an image file.
            if fileURL.conformsToUTI(type: kUTTypeImage) {
                host.uploadImageFile(fileURL)
            }
        } else if let image = objects.first as? NSImage {
            // Upload the image if it is just an screenshot image.
            host.uploadImageData(image, named: "Screenshot", in: .PNG)
        }
    }
}

extension UploadManager: HostDelegate {
    func host(_ host: Host, isUploadingImageWithPercent percent: Float) {
        print("Percent: \(percent)")
    }
    
    func host(_ host: Host, didUploadImageWithURLString urlString: String) {
        NSUserNotificationCenter.default.deliverNotification(withTitle: "Image Uploaded", subtitle: "", text: urlString)
        
        let markdownURL = "![](" + urlString + ")"
        let pasteBoard = NSPasteboard.general()
        pasteBoard.declareTypes([NSPasteboardTypeString], owner: nil)
        assert(pasteBoard.setString(markdownURL, forType: NSPasteboardTypeString),
               "Failed to write object to the general pasteboard")
    }
}
