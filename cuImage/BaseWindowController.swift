//
//  BaseWindowController.swift
//  cuImage
//
//  Created by HuLizhen on 07/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class BaseWindowController: NSWindowController {
    override var windowNibName: String? {
        return self.className.components(separatedBy: ".").last
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        let top = preferences[.keepWindowsOnTop]
        Utilities.keepWindowsOnTop(top)
    }
    
    override func showWindow(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        super.showWindow(sender)
    }
}
