//
//  StatusItemView.swift
//  cuImage
//
//  Created by Lizhen Hu on 12/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

enum StatusItemImageType {
    case appIcon
    case uploadProgress(Float)
    case draggingDestinationBox
}

// Implementation of the drag-drop-upload feature.
final class StatusItemView: NSImageView {
    fileprivate var statusItemIcon: NSImage!
    fileprivate var draggingDestinationBox: NSImage!
    private var uploadProgressImages: [NSImage]!
    fileprivate var isUploading = false
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        // Make the images used for status menu templates.
        statusItemIcon = NSImage(named: Constants.statusItemIcon)!
        statusItemIcon.isTemplate = true
        draggingDestinationBox = NSImage(named: Constants.draggingDestinationBox)!
        draggingDestinationBox.isTemplate = true
        uploadProgressImages = (0..<Constants.uploadProgressImagesCount).reduce([]) {
            var images: [NSImage] = $0.0
            images.append(NSImage(named: Constants.uploadProgress + "\($0.1)")!)
            images[$0.1].isTemplate = true
            return images
        }

        image = statusItemIcon
        
        // Unregister the default dragged types.
        unregisterDraggedTypes()
        
        // Register the dragged types for only file and image.
        let draggedTypes = [kUTTypeFileURL as String, kUTTypeImage as String]
        register(forDraggedTypes: draggedTypes)
    }
    
    func updateImage(with percent: Float) {
        guard percent >= 0 && percent <= 1 else { return }
        let index = Int((percent * Float(Constants.uploadProgressImagesCount - 1)).rounded())
        image = uploadProgressImages[index]
    }

    func updateImage(_ type: StatusItemImageType) {
        switch type {
        case .appIcon:
            image = statusItemIcon
        case .draggingDestinationBox:
            image = draggingDestinationBox
        case .uploadProgress(let percent):
            if percent >= 0 && percent <= 1 {
                let index = Int((percent * Float(Constants.uploadProgressImagesCount - 1)).rounded())
                image = uploadProgressImages[index]
            }
        }
    }
}

// MARK: - NSDraggingDestination
extension StatusItemView {
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteboard = sender.draggingPasteboard()
        let classes: [AnyClass] = [NSURL.self, NSImage.self]
        var containsImages = false
        
        if let objects = pasteboard.readObjects(forClasses: classes, options: nil) {
            for object in objects {
                var isImage = false
                
                if let url = object as? URL {
                    if url.imageFileExtension() != nil {
                        isImage = true
                    }
                } else {
                    isImage = true
                }
                
                if isImage {
                    if !UploadManager.shared.isUploading {
                        updateImage(.draggingDestinationBox)
                    }
                    containsImages = true
                    break
                }
            }
        }
        
        return containsImages ? NSDragOperation.copy : NSDragOperation()
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func wantsPeriodicDraggingUpdates() -> Bool {
        return false
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        UploadManager.shared.uploadImagesOnPasteboard(sender.draggingPasteboard())
        return true
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        NSSound(named: Constants.dropSound)?.play()
        if !UploadManager.shared.isUploading {
            updateImage(.appIcon)
        }
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        if !UploadManager.shared.isUploading {
            updateImage(.appIcon)
        }
    }
}
