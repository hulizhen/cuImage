//
//  NSAlert+Convenience.swift
//  cuImage
//
//  Created by HuLizhen on 18/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension NSAlert {
    /**
     Convenient class method to show alert dialog.
     
     - parameters:
        - window: The window on which to display the sheet.
                    With this provided, beginSheetModal(for:completionHandler:) will be called.
                    Otherwise, call runModal().
        - alertStyle: Indicates the alert’s severity level.
        - messageText: The alert’s message text or title.
        - informativeText: The alert’s informative text.
        - buttonTitles: The array of response buttons for the alert.
        - completion: The completion handler that gets called when the sheet’s modal session ends.
     */
    static func alert(for window: NSWindow? = nil, alertStyle: NSAlertStyle = .warning,
                      messageText: String, informativeText: String = "",
                      buttonTitles: [String]? = nil, completion: ((NSModalResponse) -> Void)? = nil) {
        let alert = NSAlert()
        
        alert.messageText = messageText
        alert.informativeText = informativeText
        alert.alertStyle = alertStyle
        
        // If no button titles are provided, a default "OK" button will be added.
        if let titles = buttonTitles {
            for title in titles {
                alert.addButton(withTitle: title)
            }
        }
        
        // Play sound when alerting.
        NSSound(named: Constants.alertSound)?.play()
        
        NSApp.activate(ignoringOtherApps: true)
        if let window = window {    // Call beginSheetModal(for:completionHandler:).
            alert.beginSheetModal(for: window, completionHandler: completion)
        } else {                    // Call runModal().
            let response = alert.runModal()
            if let completion = completion {
                completion(response)
            }
        }
    }
}
