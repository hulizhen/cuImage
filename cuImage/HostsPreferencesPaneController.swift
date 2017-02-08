//
//  HostsPreferencesPaneController.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

final class HostsPreferencesPaneController: BasePreferencesPaneController {
    @IBOutlet weak var hostsPopUpButton: NSPopUpButton!
    @IBOutlet weak var hostPreferencesContentView: NSView!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var validateButton: NSButton!
    @IBOutlet weak var validationResultText: NSTextField!
    @IBOutlet weak var validationResultIndicator: NSImageView!
    @IBOutlet weak var validationProgressIndicator: NSProgressIndicator!
    
    var currentHost = SupportedHost.defaultHost
    var currentHostInfoViewController: BaseViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Host info validation things.
        validationResultText.stringValue = ""
        validationProgressIndicator.isHidden = true
        validationResultIndicator.image = nil
        
        // Tool tips.
        validateButton.toolTip = LocalizedStrings.validateButtonToolTip
        saveButton.toolTip = LocalizedStrings.saveButtonToolTip
        
        setUp()
    }
    
    private func setUp() {
        if let host = preferences[.currentHost] {
            currentHost = SupportedHost(rawValue: host) ?? .defaultHost
        } else {
            preferences[.currentHost] = currentHost.rawValue
        }
        currentHostInfoViewController = currentHost.viewController

        // Populate the hosts pop up button.
        for host in SupportedHost.allCases {
            hostsPopUpButton.addItem(withTitle: host.rawValue)
            hostsPopUpButton.lastItem!.image = host.image
        }
        
        // TODO: Remove the following line after supporting more hosts.
        hostsPopUpButton.toolTip = LocalizedStrings.hostsPopUpButtonToolTip
        
        // Select the current host.
        hostsPopUpButton.selectItem(withTitle: currentHost.rawValue)
        hostPreferencesContentView.addSubview(currentHostInfoViewController.view)
    }
    
    @IBAction private func handleTappedButton(_ button: NSButton) {
        guard let controller = currentHostInfoViewController as? HostInfoViewController else { return }
        
        switch button {
        case validateButton:
            validationResultText.stringValue = LocalizedStrings.validating
            validationResultIndicator.image = nil
            validationProgressIndicator.isHidden = false
            validationProgressIndicator.startAnimation(self)
            controller.validateHostInfo { succeeded in
                self.validationProgressIndicator.stopAnimation(self)
                self.validationProgressIndicator.isHidden = true
                self.validationResultText.stringValue = LocalizedStrings.validation +
                    (succeeded ? LocalizedStrings.succeeded : LocalizedStrings.failed) + "!"
                self.validationResultIndicator.image =
                    NSImage(named: succeeded ? Constants.succeededIndicator : Constants.failedIndicator)
            }
        case saveButton:
            controller.saveHostInfo()
        default:
            break
        }
    }
}
