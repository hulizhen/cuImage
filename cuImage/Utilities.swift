//
//  Utilities.swift
//  cuImage
//
//  Created by HuLizhen on 07/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import ServiceManagement

struct Utilities {
    static func launchAtLogin(_ launch: Bool) {
        let launcherBundleIdentifier = Bundle.main.infoDictionary![Constants.launcherBundleIdentifier] as! String
        SMLoginItemSetEnabled(launcherBundleIdentifier as CFString, launch)
    }
    
    static func keepWindowsOnTop(_ top: Bool) {
        for window in NSApp.windows {
            if window.isMember(of: NSWindow.self) {
                window.level = Int(CGWindowLevelForKey(top ? .floatingWindow : .normalWindow))
            }
        }
    }
    
    static func setPasteboard(_ pasteboard: NSPasteboard = NSPasteboard.general(),
                              with urlString: String,
                              inMarkdown markdown: Bool) {
        let string = markdown ? "![](" + urlString + ")" : urlString

        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setString(string, forType: NSPasteboardTypeString)
        
        NSUserNotificationCenter.default.deliverNotification(withTitle: "Image Uploaded",
                                                             subtitle: "URL has been copied",
                                                             text: urlString)
    }
    
    static func launchEmailApplication() {
        // Closure for copying email address to general pasteboard.
        let copyEmailAddress = {
            let pasteboard = NSPasteboard.general()
            pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
            pasteboard.setString(Constants.emailRecipient, forType: NSPasteboardTypeString)
            
            NSUserNotificationCenter.default.deliverNotification(withTitle: "Email Address Copied",
                                                                 subtitle: "",
                                                                 text: Constants.emailRecipient)
        }
        
        let alert = NSAlert()
        alert.messageText = "Do you want to launch email application?"
        alert.informativeText = "You can also just copy author's email address."
        alert.addButton(withTitle: "Launch")
        alert.addButton(withTitle: "Copy")
        alert.addButton(withTitle: "Cancel")
        alert.alertStyle = .warning
        let response = alert.runModal()
        if response == NSAlertFirstButtonReturn {   // Launch
            var done = false

            // Launch email application.
            if let emailService = NSSharingService(named: NSSharingServiceNameComposeEmail) {
                emailService.recipients = [Constants.emailRecipient]
                emailService.subject = Constants.emailSubject

                if emailService.canPerform(withItems: nil) {
                    emailService.perform(withItems: [Constants.emailBody])
                    done = true
                }
            }
            
            // Offer an option of copying email address when failed to launch email application.
            if done == false {
                let alert = NSAlert()
                alert.messageText = "Failed to launch email application. Copy Author's email address?"
                alert.informativeText = "Please launch email application yourself."
                alert.addButton(withTitle: "Copy")
                alert.addButton(withTitle: "Cancel")
                alert.alertStyle = .warning
                let response = alert.runModal()
                if response == NSAlertFirstButtonReturn {   // Copy
                    copyEmailAddress()
                }
            }
        } else if response == NSAlertSecondButtonReturn {   // Copy
            copyEmailAddress()
        }
    }
}
