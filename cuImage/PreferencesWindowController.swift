//
//  PreferencesWindowController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    @IBOutlet weak var toolbar: NSToolbar!
    @IBOutlet weak var generalToolbarItem: NSToolbarItem!
    
    lazy var generalPreferencesViewController: GeneralPreferencesViewController = GeneralPreferencesViewController()
    
    override var windowNibName: String? {
        return self.className.components(separatedBy: ".").last
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        toolbar.selectedItemIdentifier = generalToolbarItem.itemIdentifier
        window!.contentViewController = generalPreferencesViewController
    }
    
    @IBAction func handleTappedToolbarItem(_ item: NSToolbarItem) {
        var controller: NSViewController!
        switch item {
        case generalToolbarItem:
            controller = generalPreferencesViewController
        default:
            break
        }
        
        // Keep the top-left point of window fixed.
        let frame = window!.frame
        let topLeftOrigin = NSPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height)
        window!.contentViewController = controller
        window!.setFrameTopLeftPoint(topLeftOrigin)
    }
}
