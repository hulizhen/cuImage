//
//  UploadManager.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import iRate

class UploadItem {
    init(data: Data, name: String) {
        self.data = data
        self.name = name
        self.totalBytes = data.count
        self.uploadedBytes = 0
    }
    
    var data: Data
    var name: String
    var totalBytes: Int
    var uploadedBytes: Int
}

final class UploadManager {
    static let shared = UploadManager()
    
    // Current host.
    private var host: Host?
    
    // Qqueue for uploading.
    private let serialUploadQueue = DispatchQueue(label: "SerialUploadQueue")
    private let concurrentUploadQueue = DispatchQueue(label: "ConcurrentUploadQueue", attributes: .concurrent)
    
    // Max concurrent upload operation count.
    fileprivate var uploadSemaphore = DispatchSemaphore(value: preferences[.maxActiveUploadTasks])

    // Items to be uploaded.
    fileprivate var uploadItems = [String: UploadItem]()
    
    // Cache URLs, and copy them to pasteboard when all items in @uploadItems uploaded.
    fileprivate var urlStrings = [String]()

    // Succeeded and failed items count for all items in @uploadItems.
    fileprivate var succeededItems = 0
    fileprivate var failedItems = 0
    var isUploading: Bool {
        return succeededItems + failedItems != uploadItems.count
    }
    
    // Total bytes and uploaded bytes for all items in @uploadItems.
    fileprivate var totalBytes = 0
    fileprivate var uploadedBytes = 0
    fileprivate var uploadPercent: Float {
        return Float(uploadedBytes) / Float(totalBytes)
    }
    
    private init() {
        host = QiniuHost(delegate: self)
    }

    private func reset() {
        uploadSemaphore = DispatchSemaphore(value: preferences[.maxActiveUploadTasks])
        
        uploadItems = [String: UploadItem]()
        urlStrings = [String]()
        
        succeededItems = 0
        failedItems = 0
        
        totalBytes = 0
        uploadedBytes = 0
    }
    
    fileprivate func finish() {
        if !isUploading {
            let copyURLWhenUploaded = preferences[.copyURLWhenUploaded]
            let title = String(format: LocalizedStrings.uploadResult, succeededItems, failedItems)
            let informativeText = (copyURLWhenUploaded && succeededItems > 0) ?
                LocalizedStrings.urlOfUploadedImageCopied : ""
            
            if copyURLWhenUploaded && succeededItems > 0 {
                NSPasteboard.general.addURLStrings(urlStrings, markdown: preferences[.useMarkdownURL])
            }
            NSUserNotificationCenter.default.deliverNotification(with: title, informativeText: informativeText)
            StatusItemController.shared.updateStatusItemStatus(.idle)
        }
    }
    
    // Add to @uploadItems, upload them later.
    private func uploadItem(_ item: UploadItem) {
        uploadItems[item.name] = item
        totalBytes += item.data.count
        
        let uploading = StatusItemStatus.uploading(uploadPercent, succeededItems + failedItems, uploadItems.count)
        StatusItemController.shared.updateStatusItemStatus(uploading)

        // No need to introduce the weak-strong-dance, due to the UploadManager is a shared singleton.
        serialUploadQueue.async {
            self.uploadSemaphore.wait()
            self.concurrentUploadQueue.async {
                self.host?.uploadData(item.data, named: item.name)
            }
        }
    }
    
    private func alertForNoImages() {
        NSAlert.alert(messageText: LocalizedStrings.noImagesToUploadAlertMessageText,
                      informativeText: LocalizedStrings.noImagesToUploadAlertInformativeText)
    }
    
    /// Upload the images on pasteboard.
    ///
    /// - Parameter pasteboard: The pasteboard on which the images are, general pasteboard by default.
    func uploadImagesOnPasteboard(_ pasteboard: NSPasteboard = NSPasteboard.general) {
        if !isUploading {
            reset()
        }
        
        guard host != nil else { return }
        let classes: [AnyClass] = [NSURL.self, NSImage.self]
        
        // Read URLs or images data from pasteboard.
        guard let objects = pasteboard.readObjects(forClasses: classes, options: nil) else {
            alertForNoImages()
            return
        }

        let useJPEGCompression = preferences[.useJPEGCompression]
        let jpegCompressionQuality = preferences[.jpegCompressionQuality]
        let jpegString = NSBitmapImageRep.FileType.jpeg.string
        let pngString = NSBitmapImageRep.FileType.png.string
        
        // Get and upload the images on pasteboard.
        for object in objects {
            var imageData: Data!
            var fileName: String!
            
            if let url = object as? URL,
                let fileExtension = url.imageFileExtension() {
                // Get file name without path extension.
                fileName = url.deletingPathExtension().lastPathComponent
                
                // Do not compress gif image file.
                let isGIF = url.conformsToUTI(type: kUTTypeGIF)
                
                if useJPEGCompression && !isGIF {
                    let image = NSImage(contentsOf: url)
                    imageData = image?.jpegRepresentation(with: jpegCompressionQuality)
                } else {
                    imageData = try? Data(contentsOf: url)
                }
                fileName.append("." + (useJPEGCompression && !isGIF ? jpegString : fileExtension))
            } else {
                let image = objects.first as? NSImage

                // Use PNG if not need compression, otherwise use JPEG for screenshots.
                if useJPEGCompression {
                    imageData = image?.jpegRepresentation(with: jpegCompressionQuality)
                    fileName = "Screenshot." + jpegString
                } else {
                    imageData = image?.pngRepresentation()
                    fileName = "Screenshot." + pngString
                }
            }
            
            if imageData != nil && fileName != nil {
                // Insert current date and random characters at the beginning of file name.
                let date = Date.simpleFormatter.string(from: Date())
                let characters = String.random(length: Constants.randomCharactersLength)
                
                fileName = date + "_" + characters + "_" + fileName
                uploadItem(UploadItem(data: imageData, name: fileName))
            }
        }
        
        if uploadItems.count <= 0 {
            alertForNoImages()
            reset()
        }
        
        iRate.sharedInstance().logEvent(false)
    }
}

extension UploadManager: HostDelegate {
    func host(_ host: Host, isUploadingDataNamed name: String, percent: Float) {
        guard let name = name.components(separatedBy: "/").last,
            let item = uploadItems[name] else {
                return
        }
        
        // Update total bytes uploaded.
        uploadedBytes -= item.uploadedBytes
        item.uploadedBytes = Int((percent * Float(item.totalBytes)).rounded())
        uploadedBytes += item.uploadedBytes
        
        let uploading = StatusItemStatus.uploading(uploadPercent, succeededItems + failedItems, uploadItems.count)
        StatusItemController.shared.updateStatusItemStatus(uploading)
    }
    
    func host(_ host: Host, didSucceedToUploadDataNamed name: String, urlString: String) {
        uploadSemaphore.signal()

        // Add uploaded image to history.
        let managedObjectContext = CoreDataController.shared.managedObjectContext
        let uploadedItem = NSEntityDescription.insertNewObject(forEntityName: "UploadedItem",
                                                               into: managedObjectContext) as! UploadedItem
        uploadedItem.date = NSDate() as Date
        uploadedItem.urlString = urlString
        
        if let data = uploadItems[name]?.data,
            let image = NSImage(data: data),
            let thumbnail = image.thumbnail(maxSize: Constants.maxSizeOfthumbnail),
            let thumbnailTiff = thumbnail.tiffRepresentation {
            uploadedItem.thumbnail = NSData(data: thumbnailTiff) as Data
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save managed object context: \(error)")
        }
        
        urlStrings.append(urlString)
        succeededItems += 1
        finish()
    }
    
    func host(_ host: Host, didFailToUploadDataNamed name: String, error: NSError) {
        uploadSemaphore.signal()
        
        guard let name = name.components(separatedBy: "/").last,
            let item = uploadItems[name] else {
                return
        }
        
        // Update total bytes uploaded even failed to upload this item.
        uploadedBytes -= item.uploadedBytes
        item.uploadedBytes = item.totalBytes
        uploadedBytes += item.uploadedBytes

        failedItems += 1
        finish()
    }
}
