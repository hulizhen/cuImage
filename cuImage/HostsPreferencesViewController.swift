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
    
    var currentHostPreferencesViewController: NSViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentHost = SupportedHost(rawValue: hostsPreferences.currentHost)!
        currentHostPreferencesViewController = currentHost.viewController

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
        hostPreferencesContentView.addSubview(currentHostPreferencesViewController.view)
    }
    
    @IBAction private func saveHostPreferences(_ button: NSButton) {
        if let controller = currentHostPreferencesViewController as? HostsPreferencesSavable {
            controller.saveHostPreferences()
        }
    }
}
