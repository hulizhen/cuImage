//
//  BaseWindowController.swift
//  cuImage
//
//  Created by Lizhen Hu on 07/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

class BaseWindowController: NSWindowController {
    override var windowNibName: String? {
        return self.className.components(separatedBy: ".").last
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        
        let top = preferences[.keepWindowsOnTop]
        keepWindowsOnTop(top)
    }
    
    override func showWindow(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        super.showWindow(sender)
    }
}
