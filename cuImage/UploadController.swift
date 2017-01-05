//
//  UploadController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class UploadController: NSObject {    
    static let shared = UploadController()
    
    private var host: Host?
    
    private override init() {
        super.init()
        
        host = QiniuHost(WithDelegate: self)
    }
    
    /// Upload the image on pasteboard.
    /// - Parameter pasteboard: the pasteboard on which the image is. Use the general pasteboard by default.
    func uploadImageOnPasteboard(_ pasteboard: NSPasteboard = NSPasteboard.general()) {
        if let image = readImageFromPasteBoard() {
            host?.uploadImage(image, named: "Screenshot", in: .PNG)
        }
    }
    
    private func readImageFromPasteBoard() -> NSImage? {
        let pasteBoard = NSPasteboard.general()
        let classes = [NSImage.self]
        var image: NSImage?
        
        if pasteBoard.canReadObject(forClasses: classes, options: nil) {
            let array = pasteBoard.readObjects(forClasses: classes, options: nil)
            image = array?.first as? NSImage
        }
        
        return image
    }
}

extension UploadController: HostDelegate {
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
