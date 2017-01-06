//
//  HostsPreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

protocol HostsPreferencesSavable: class {
    func saveHostPreferences();
}

class HostsPreferencesViewController: NSViewController {
    @IBOutlet weak var hostsPopUpButton: NSPopUpButton!
    @IBOutlet weak var hostPreferencesContentView: NSView!
    
    var currentHost: SupportedHost!
    var currentHostInfoViewController: NSViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    private func setUp() {
        currentHost = SupportedHost(rawValue: preferences[.currentHost]) ?? .defaultHost
        currentHostInfoViewController = currentHost.viewController

        // Populate the hosts pop up button.
        for host in SupportedHost.allCases {
            hostsPopUpButton.addItem(withTitle: host.rawValue)
            hostsPopUpButton.lastItem!.image = host.image
        }
        
        // Select the current host.
        hostsPopUpButton.selectItem(withTitle: currentHost.rawValue)
        hostPreferencesContentView.addSubview(currentHostInfoViewController.view)
    }
    
    @IBAction private func saveHostPreferences(_ button: NSButton) {
        if let controller = currentHostInfoViewController as? HostsPreferencesSavable {
            controller.saveHostPreferences()
        }
    }
}
