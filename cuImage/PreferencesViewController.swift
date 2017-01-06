//
//  PreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    override func viewDidAppear() {
        super.viewDidAppear()
        
        let window = view.window!
        
        // Set preferences window title according to its content view controller.
        window.title = title!
        
        // Stop get focus when switching to new prefrence pane.
        window.makeFirstResponder(nil)
    }
}
