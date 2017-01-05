//
//  GeneralPreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class GeneralPreferencesViewController: NSViewController {
    let generalPreferences = GeneralPreferences.shared
    
    @IBOutlet weak var launchAtLoginButton: NSButton!
    @IBOutlet weak var keepWindowsOnTopButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp() {
        // Establish bindings between models and views.
        launchAtLoginButton.bind(NSValueBinding, to: generalPreferences, withKeyPath: GeneralPreferences.Key.launchAtLogin)
        keepWindowsOnTopButton.bind(NSValueBinding, to: generalPreferences, withKeyPath: GeneralPreferences.Key.keepWindowsOnTop)
    }
}
