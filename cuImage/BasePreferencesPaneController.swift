//
//  BasePreferencesPaneController.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class BasePreferencesPaneController: NSViewController {
    override func viewDidAppear() {
        super.viewDidAppear()
        
        // Prevent getting focused when switching to new preference pane.
        view.window?.makeFirstResponder(nil)
    }
}
