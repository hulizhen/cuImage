//
//  HostsPreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class HostsPreferencesViewController: NSViewController {
    let hostsPreferences = HostsPreferences.shared
    
    @IBOutlet weak var hostPreferencesContentView: NSView!
    @IBOutlet weak var qiniuHostPreferencesView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hostPreferencesContentView.addSubview(qiniuHostPreferencesView)
    }
    
    @IBAction private func saveHostPreferences(_ button: NSButton) {
    }
}
