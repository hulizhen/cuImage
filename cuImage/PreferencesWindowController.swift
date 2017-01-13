//
//  PreferencesWindowController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class PreferencesWindowController: BaseWindowController, NSWindowDelegate {
    @IBOutlet weak var toolbar: NSToolbar!
    @IBOutlet weak var generalToolbarItem: NSToolbarItem!
    @IBOutlet weak var shortcutsToolbarItem: NSToolbarItem!
    @IBOutlet weak var hostsToolbarItem: NSToolbarItem!
    
    var preferencesViewControllers = [GeneralPreferencesViewController(),
                                      ShortcutsPreferencesViewController(),
                                      HostsPreferencesViewController()]
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        toolbar.selectedItemIdentifier = generalToolbarItem.itemIdentifier
        window!.contentViewController = preferencesViewControllers.first
    }
        
    @IBAction func handleTappedToolbarItem(_ item: NSToolbarItem) {
        let controller = preferencesViewControllers[item.tag]
        
        // Keep the top-left point of window fixed.
        let frame = window!.frame
        let topLeftOrigin = NSPoint(x: frame.origin.x, y: frame.origin.y + frame.size.height)
        window!.contentViewController = controller
        window!.setFrameTopLeftPoint(topLeftOrigin)        
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        guard let preferencesViewController =
            preferencesViewControllers[hostsToolbarItem.tag] as? HostsPreferencesViewController,
            let infoViewController =
            preferencesViewController.currentHostInfoViewController as? HostInfoViewController else {
                return true
        }
        
        let changed = infoViewController.alertToSaveInfo(for: window!) { response in
            var terminate = true
            
            switch response {
            case NSAlertFirstButtonReturn:   // Save
                infoViewController.saveHostInfo()
            case NSAlertSecondButtonReturn:  // Cancel
                terminate = false
            case NSAlertThirdButtonReturn:   // Discard
                infoViewController.discardHostInfo()
            default:
                break
            }
            if terminate {
                self.window!.close()
            }
            
            // In case the application calls windowShouldClose(_:).
            NSApp.reply(toApplicationShouldTerminate: terminate)
        }
        
        return !changed
    }
}
