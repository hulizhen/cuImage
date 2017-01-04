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
    
    @IBOutlet weak var hostsPopUpButton: NSPopUpButton!
    @IBOutlet weak var hostPreferencesContentView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setUp()
    }
    
    private func setUp() {
        // Populate the hosts pop up button.
        for host in SupportedHost.allCases {
            hostsPopUpButton.addItem(withTitle: host.rawValue)
            hostsPopUpButton.lastItem!.image = host.image
        }
        
        // Establish bindings between models and views.
        hostsPopUpButton.bind(NSSelectedValueBinding, to: hostsPreferences, withKeyPath: HostsPreferences.Key.currentHost)
        
        // Select the current host.
        let currentHostPreferencesView = SupportedHost(rawValue: hostsPreferences.currentHost)!.view
        hostPreferencesContentView.addSubview(currentHostPreferencesView)
    }
    
    @IBAction private func saveHostPreferences(_ button: NSButton) {
    }
}
