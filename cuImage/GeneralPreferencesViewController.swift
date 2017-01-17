//
//  GeneralPreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class GeneralPreferencesViewController: BasePreferencesViewController {
    @IBOutlet weak var notificationPreferencesButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "General"
    }
    
    @IBAction func handleTappedButton(_ button: NSButton) {
        let notificationPreferencesPaneURL = URL(fileURLWithPath: Constants.notificationPreferencesPane)
        NSWorkspace.shared().open(notificationPreferencesPaneURL)
    }
}
