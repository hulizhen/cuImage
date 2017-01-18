//
//  StatusItemView.swift
//  cuImage
//
//  Created by HuLizhen on 12/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

// Implementation of the drag-drop-upload feature.
final class StatusItemView: NSImageView {
    fileprivate let uploadManager = UploadManager.shared
    fileprivate var statusItemIcon: NSImage!
    fileprivate var draggingDestinationBox: NSImage!
    private var uploadingProgressImages: [NSImage]!
    
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
        uploadingProgressImages = (0..<Constants.uploadingProgressCount).reduce([]) {
            var images: [NSImage] = $0.0
            images.append(NSImage(named: Constants.uploadingProgress + "\($0.1)")!)
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
        let index = Int((percent * Float(Constants.uploadingProgressCount - 1)).rounded())
        image = uploadingProgressImages[index]
    }
    
    func resetImage() {
        image = statusItemIcon
    }
}

// MARK: - NSDraggingDestination
extension StatusItemView {
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteboard = sender.draggingPasteboard()
        let classes: [AnyClass] = [NSURL.self, NSImage.self]
        guard let objects = pasteboard.readObjects(forClasses: classes, options: nil) else { return NSDragOperation() }
        
        if let url = objects.first as? URL {
            if url.imageFileExtension() != nil {
                image = draggingDestinationBox
                return NSDragOperation.copy
            }
        }
        
        return NSDragOperation()
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    override func wantsPeriodicDraggingUpdates() -> Bool {
        return false
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        image = statusItemIcon
        let uploadManager = (NSApp.delegate as! AppDelegate).uploadManager
        uploadManager.uploadImageOnPasteboard(sender.draggingPasteboard())
        return true
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
        NSSound(named: Constants.dropSound)?.play()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        image = statusItemIcon
    }
}
