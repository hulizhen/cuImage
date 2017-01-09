//
//  GeneralPreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class GeneralPreferencesViewController: BasePreferencesViewController {
    @IBOutlet weak var launchAtLoginButton: NSButton!
    @IBOutlet weak var keepWindowsOnTopButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "General"
    }
}
