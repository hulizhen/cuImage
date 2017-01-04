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
    
    // Properties below are bound to objects in Interface Builder.
    let qiniuHostPreferences = QiniuHostPreferences()
    
    @IBOutlet weak var hostsPopUpButton: NSPopUpButton!
    @IBOutlet weak var hostPreferencesContentView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp() {
        // Populate the hosts pop up button.
        for host in SupportedHost.allCases {
            let item = NSMenuItem()
            item.title = host.rawValue
            item.image = host.image
            hostsPopUpButton.menu!.addItem(item)
        }
        
        // Select the current host.
        hostPreferencesContentView.addSubview(hostsPreferences.currentHost.view)
    }
    
    @IBAction private func saveHostPreferences(_ button: NSButton) {
    }
}
