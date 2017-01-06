//
//  AboutWindowController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {
    override var windowNibName: String? {
        return self.className.components(separatedBy: ".").last
    }
}
