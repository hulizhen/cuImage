//
//  AboutWindowController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

final class AboutWindowController: BaseWindowController {
    static let shared = AboutWindowController()

    @IBOutlet weak var copyrightLabel: NSTextField!

    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Sets the window’s location to the center of the screen.
        window?.center()
        
        let copyright = Bundle.main.infoDictionary![Constants.humanReadableCopyright] as! String
        copyrightLabel.stringValue = copyright
    }
}
