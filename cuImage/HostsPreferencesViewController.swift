//
//  HostsPreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class HostsPreferencesViewController: BasePreferencesViewController {
    @IBOutlet weak var hostsPopUpButton: NSPopUpButton!
    @IBOutlet weak var hostPreferencesContentView: NSView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var validateButton: NSButton!
    @IBOutlet weak var validateResultText: NSTextField!
    @IBOutlet weak var validatingIndicator: NSProgressIndicator!
    
    var currentHost: SupportedHost!
    var currentHostInfoViewController: NSViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hosts"
        validateResultText.stringValue = ""
        
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
        
        // TODO: Remove the following line after supporting more hosts.
        hostsPopUpButton.toolTip = "Currently support Qiniu host only. Wait a moment, please :)"
        
        // Select the current host.
        hostsPopUpButton.selectItem(withTitle: currentHost.rawValue)
        hostPreferencesContentView.addSubview(currentHostInfoViewController.view)
    }
    
    @IBAction private func handleTappedButton(_ button: NSButton) {
        guard let controller = currentHostInfoViewController as? HostInfoViewController else { return }
        
        switch button {
        case validateButton:
            validatingIndicator.startAnimation(self)
            controller.validateHostInfo { succeeded in
                self.validateResultText.stringValue = (succeeded ? "Valid" : "Invalid") + " Configurations!"
                self.validatingIndicator.stopAnimation(self)
            }
        case saveButton:
            controller.saveHostInfo()
        default:
            break
        }
    }
}
