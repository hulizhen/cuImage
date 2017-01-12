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
        
        // Register the dragged types for only image and file.
        let draggedTypes = [kUTTypeImage as String, kUTTypeFileURL as String]
        register(forDraggedTypes: draggedTypes)
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteboard = sender.draggingPasteboard()
        let none = NSDragOperation()
        let operations = NSDragOperation.copy
        guard let types = pasteboard.types else { return none }
        
        // Return none if the file is not a image file.
        if types.contains(kUTTypeFileURL as String) {
            let objects = pasteboard.readObjects(forClasses: [NSURL.self], options: nil)
            guard let fileURL = objects?.first as? URL else { return none }

            if fileURL.conformsToUTI(type: kUTTypeImage) == false {
                return none
            }
        }

        image = draggingDestinationBox
        return operations
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        sender.animatesToDestination = true
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        image = statusItemIcon
        return true
    }
    
    override func concludeDragOperation(_ sender: NSDraggingInfo?) {
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        image = statusItemIcon
    }
}
