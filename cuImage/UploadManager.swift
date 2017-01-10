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
        if let image = readImageFromPasteBoard() {
            host?.uploadImage(image, named: "Screenshot", in: .PNG)
        }
    }
    
    private func readImageFromPasteBoard() -> NSImage? {
        let pasteboard = NSPasteboard.general()
        var image: NSImage?
        
        guard let types = pasteboard.types else { return nil }
        
        // Read image file if it is.
        if types.contains(kUTTypeFileURL as String) {
            if let files = pasteboard.propertyList(forType: NSFilenamesPboardType) as? NSArray,
                let file = files.firstObject as? String {
                image = NSImage(contentsOfFile: file)
            }
        }
        
        // Read image data on pasteboard.
        if image == nil && types.contains(NSPasteboardTypePNG) {
            if let objects = pasteboard.readObjects(forClasses: [NSImage.self], options: nil) {
                image = objects.first as? NSImage
            }
        }
        
        return image
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
