//
//  PreferencesWindowController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

final class PreferencesWindowController: BaseWindowController, NSWindowDelegate {
    static let shared = PreferencesWindowController()
    
    @IBOutlet weak var toolbar: NSToolbar!
    @IBOutlet weak var generalToolbarItem: NSToolbarItem!
    @IBOutlet weak var shortcutsToolbarItem: NSToolbarItem!
    @IBOutlet weak var hostsToolbarItem: NSToolbarItem!
    
    var preferencesPaneControllers = [GeneralPreferencesPaneController(),
                                      ShortcutsPreferencesPaneController(),
                                      HostsPreferencesPaneController()]
        
    override func windowDidLoad() {
        super.windowDidLoad()
        
        guard let window = window else { return }
        guard let leftmostItem = window.toolbar?.items.first else { return }
        
        // Set the default pane.
        window.toolbar?.selectedItemIdentifier = leftmostItem.itemIdentifier
        showPreferencesPane(with: leftmostItem)
        
        // Sets the window’s location to the center of the screen.
        window.center()
    }

    @IBAction func showPreferencesPane(with item: NSToolbarItem) {
        guard let window = window else { return }
        
        // Make sure the toolbar item is selected.
        // In case the method is called when toolbar item responds to
        // key events(ex. tap spacebar while it is focused) instead of mouse click.
        toolbar.selectedItemIdentifier = item.itemIdentifier
        
        let controller = preferencesPaneControllers[item.tag]
        
        // Important: Nil out the content view controller.
        // This makes window resize itself according to its content view every time.
        window.contentViewController = nil
        
        // Resize window to fit to new view.
        var frame = window.frameRect(forContentRect: controller.view.frame)
        frame.origin = window.frame.origin
        frame.origin.y += window.frame.height - frame.height
        window.setFrame(frame, display: false, animate: true)
        
        // Set window title.
        window.title = item.paletteLabel
        
        // Update content view controller.
        window.contentViewController = controller
    }
    
    func showHostPreferencesPane() {
        showWindow(self)
        
        guard let window = window else { return }
        window.toolbar?.selectedItemIdentifier = hostsToolbarItem.itemIdentifier
        showPreferencesPane(with: hostsToolbarItem)
    }
    
    func windowShouldClose(_ sender: Any) -> Bool {
        guard let preferencesPaneController =
            preferencesPaneControllers[hostsToolbarItem.tag] as? HostsPreferencesPaneController,
            let infoViewController =
            preferencesPaneController.currentHostInfoViewController as? HostInfoViewController else {
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
