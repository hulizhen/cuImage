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
    private let statusItemIcon = NSImage(named: Constants.statusItemIcon)!
    private let draggingDestinationBox = NSImage(named: Constants.draggingDestinationBox)!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        statusItemIcon.isTemplate = true
        draggingDestinationBox.isTemplate = true

        image = statusItemIcon
        
        // Unregister the default dragged types.
        unregisterDraggedTypes()
        
        // Register the dragged types for only file and image.
        let draggedTypes = [kUTTypeFileURL as String, kUTTypeImage as String]
        register(forDraggedTypes: draggedTypes)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteboard = sender.draggingPasteboard()
        let classes: [AnyClass] = [NSURL.self, NSImage.self]
        guard let objects = pasteboard.readObjects(forClasses: classes, options: nil) else { return NSDragOperation() }
        
        if let url = objects.first as? URL {
            if url.isImageFileURL() {
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
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        image = statusItemIcon
    }
}
