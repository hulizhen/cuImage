//
//  GeneralPreferencesPaneController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

final class GeneralPreferencesPaneController: BasePreferencesPaneController {
    @IBOutlet weak var notificationPreferencesButton: NSButton!
    
    @IBAction func handleTappedButton(_ button: NSButton) {
        let notificationPreferencesPaneURL = URL(fileURLWithPath: Constants.notificationPreferencesPane)
        NSWorkspace.shared().open(notificationPreferencesPaneURL)
    }
}
