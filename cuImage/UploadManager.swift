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
    
    /**
     Upload the image on pasteboard.
     
     - parameters:
        - pasteboard: the pasteboard on which the image is, general pasteboard by default.
     */
    func uploadImageOnPasteboard(_ pasteboard: NSPasteboard = NSPasteboard.general()) {
        guard let host = host else { return }
        let classes: [AnyClass] = [NSURL.self, NSImage.self]
        
        let alertNoImagesToUpload = {
            NSAlert.alert(messageText: "No images to upload.",
                          informativeText: "Before uploading, you should take a screenshort, copy images or drag images to cuImage icon on status bar.")
        }
        
        guard let objects = pasteboard.readObjects(forClasses: classes, options: nil) else {
            alertNoImagesToUpload()
            return
        }
        
        var data: Data?
        var name: String?
        if let url = objects.first as? URL {
            if let fileExtension = url.imageFileExtension() {
                data = try? Data(contentsOf: url)
                name = url.lastPathComponent
                if url.pathExtension == "" {
                    name = name! + "." + fileExtension
                }
            }
        } else if let image = (objects.first as? NSImage) {
            if let tiff = image.tiffRepresentation {
                let bitmap = NSBitmapImageRep(data: tiff)
                data = bitmap?.representation(using: .JPEG, properties: [:])
                name = "Screenshot." + NSBitmapImageFileType.JPEG.string
            }
        }
        
        if data != nil {
            host.uploadImageData(data!, named: name!)
        } else {
            alertNoImagesToUpload()
        }
        
        // Initialize the uploading progress with zero.
        StatusItemController.shared.statusItemView.updateImage(with: 0)
    }
}

extension UploadManager: HostDelegate {
    func host(_ host: Host, isUploadingImageWithPercent percent: Float) {
        StatusItemController.shared.statusItemView.updateImage(with: percent)
    }
    
    func host(_ host: Host, didSucceedToUploadImage image: NSImage, urlString: String) {
        if preferences[.copyURLWhenUploaded] {
            Utilities.setPasteboard(with: urlString, inMarkdown: preferences[.useMarkdownStyleURL])
        }
        
        // Add the uploaded image to history.
        let managedObjectContext = CoreDataController.shared.managedObjectContext
        let uploadedItem = NSEntityDescription.insertNewObject(forEntityName: "UploadedItem",
                                                                into: managedObjectContext) as! UploadedItem
        uploadedItem.date = NSDate()
        uploadedItem.urlString = urlString
        if let imageTiff = image.tiffRepresentation,
            let thumbnail = image.thumbnail(maxSize: 200),
            let thumbnailTiff = thumbnail.tiffRepresentation {
            uploadedItem.image = NSData(data: imageTiff)
            uploadedItem.thumbnail = NSData(data: thumbnailTiff)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        StatusItemController.shared.statusItemView.resetImage()
    }
    
    func host(_ host: Host, didFailToUploadImage image: NSImage, error: NSError) {
        StatusItemController.shared.statusItemView.resetImage()
    }
}
