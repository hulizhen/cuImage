//
//  UploadManager.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

fileprivate struct UploadStatus {
    var isUploading = false
    
    var totalItemsCount = 0
    var succeededItemsCount = 0
    var failedItemsCount = 0
    var isFinished: Bool {
        return succeededItemsCount + failedItemsCount == totalItemsCount
    }
    
    var totalBytesCount = 0
    var uploadedBytesCount = 0
    var percent: Float {
        return Float(uploadedBytesCount) / Float(totalBytesCount)
    }
    
    // Cache and copy to pasteboard at last.
    var urlStrings = [String]()
    
    mutating func reset() {
        self = UploadStatus()
    }
    
    mutating func notifyIfFinished() {
        if isFinished {
            let copyURLWhenUploaded = preferences[.copyURLWhenUploaded]
            let title = String(format: LocalizedStrings.uploadResult, succeededItemsCount, failedItemsCount)
            let informativeText = (copyURLWhenUploaded && succeededItemsCount > 0) ?
                LocalizedStrings.urlOfUploadedImageCopied : ""
            
            if copyURLWhenUploaded && succeededItemsCount > 0 {
                NSPasteboard.general().addURLStrings(urlStrings, markdown: preferences[.useMarkdownURL])
            }
            StatusItemController.shared.statusItemView.resetImage()
            NSUserNotificationCenter.default.deliverNotification(with: title, informativeText: informativeText)
            reset()
        }
    }
}

fileprivate struct UploadItem {
    init(imageData: Data, totalBytesCount: Int, uploadedBytesCount: Int = 0) {
        self.imageData = imageData
        self.totalBytesCount = totalBytesCount
        self.uploadedBytesCount = uploadedBytesCount
    }
    
    var imageData: Data
    var totalBytesCount: Int
    var uploadedBytesCount: Int
}

final class UploadManager {
    static let shared = UploadManager()
    private var host: Host?
    
    fileprivate var uploadItems: [String: UploadItem]!
    fileprivate var uploadStatus = UploadStatus()
    
    private init() {
        host = QiniuHost(delegate: self)
    }
    
    /**
     Upload the images on pasteboard.
     
     - parameters:
        - pasteboard: the pasteboard on which the images are, general pasteboard by default.
     */
    func uploadImagesOnPasteboard(_ pasteboard: NSPasteboard = NSPasteboard.general()) {
        guard let host = host else { return }
        let classes: [AnyClass] = [NSURL.self, NSImage.self]
        
        let alertForNoImages = {
            NSAlert.alert(messageText: LocalizedStrings.noImagesToUploadAlertMessageText,
                          informativeText: LocalizedStrings.noImagesToUploadAlertInformativeText)
        }
        
        // Reset upload status, alert if currently uploading.
        if uploadStatus.isUploading {
            NSAlert.alert(messageText: LocalizedStrings.uploadingAlertMessageText)
            return
        } else {
            uploadStatus.reset()
            uploadItems = [:]

            uploadStatus.isUploading = true
        }

        // Read URLs or images data from pasteboard.
        guard let objects = pasteboard.readObjects(forClasses: classes, options: nil) else {
            alertForNoImages()
            uploadStatus.isUploading = false
            return
        }

        let useJPEGCompression = preferences[.useJPEGCompression]
        let jpegCompressionQuality = preferences[.jpegCompressionQuality]
        let jpegString = NSBitmapImageFileType.JPEG.string
        
        // Get the images on pasteboard and add them to 'uploadItems'.
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
                    imageData = image?.JPEGRepresentation(with: jpegCompressionQuality)
                } else {
                    imageData = try? Data(contentsOf: url)
                }
                fileName.append("." + (useJPEGCompression && !isGIF ? jpegString : fileExtension))
            } else {
                // Always use JPEG for screenshots, but the compression quality depends on users' preferences.
                let image = objects.first as? NSImage
                let compressionQuality = useJPEGCompression ? jpegCompressionQuality : 1.0
                imageData = image?.JPEGRepresentation(with: compressionQuality)
                fileName = "Screenshot." + jpegString
            }
            
            if imageData != nil && fileName != nil {
                // Insert current date and random characters at the beginning of file name.
                let date = Date.simpleFormatter.string(from: Date())
                let characters = String.random(length: Constants.randomCharactersLength)
                
                fileName = date + "_" + characters + "_" + fileName
                uploadItems[fileName] = UploadItem(imageData: imageData, totalBytesCount: imageData.count)
                
                uploadStatus.totalBytesCount += imageData.count
                uploadStatus.totalItemsCount += 1
            }
        }
        
        if uploadItems.count > 0 {
            // Upload all of these images.
            for (fileName, uploadItem) in uploadItems {
                host.uploadImageData(uploadItem.imageData, named: fileName)
            }
        } else {
            alertForNoImages()
            uploadStatus.isUploading = false
        }
    }
}

extension UploadManager: HostDelegate {
    func host(_ host: Host, isUploadingImageNamed name: String, percent: Float) {
        guard var uploadItem = uploadItems[name] else { return }
        
        // Update total bytes uploaded.
        uploadStatus.uploadedBytesCount -= uploadItem.uploadedBytesCount
        uploadItem.uploadedBytesCount = Int((percent * Float(uploadItem.totalBytesCount)).rounded())
        uploadStatus.uploadedBytesCount += uploadItem.uploadedBytesCount
        uploadItems[name] = uploadItem
        
        StatusItemController.shared.statusItemView.updateImage(with: uploadStatus.percent)
    }
    
    func host(_ host: Host, didSucceedToUploadImageNamed name: String, urlString: String) {
        // Add uploaded image to history.
        let managedObjectContext = CoreDataController.shared.managedObjectContext
        let uploadedItem = NSEntityDescription.insertNewObject(forEntityName: "UploadedItem",
                                                               into: managedObjectContext) as! UploadedItem
        uploadedItem.date = NSDate()
        uploadedItem.urlString = urlString
        
        if let data = uploadItems[name]?.imageData,
            let image = NSImage(data: data),
            let thumbnail = image.thumbnail(maxSize: Constants.maxSizeOfthumbnail),
            let thumbnailTiff = thumbnail.tiffRepresentation {
            uploadedItem.thumbnail = NSData(data: thumbnailTiff)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save managed object context: \(error)")
        }
        
        // Copy URL if prefered.
        if preferences[.copyURLWhenUploaded] {
            uploadStatus.urlStrings.append(urlString)
        }
        
        uploadStatus.succeededItemsCount += 1
        uploadStatus.notifyIfFinished()
    }
    
    func host(_ host: Host, didFailToUploadImageNamed name: String, error: NSError) {
        uploadStatus.failedItemsCount += 1
        uploadStatus.notifyIfFinished()
    }
}
