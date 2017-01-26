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
    
    static func systemInformation() -> String {
        var information = ""
        let processInfo = ProcessInfo()
        
        // Cloure for getting system profile.
        let systemProfile = { (key: String) -> String in
            var info: String?
            var count: Int = 0
            
            sysctlbyname(key, nil, &count, nil, 0)
            if count > 0 {
                var data = [UInt8](repeating: 0, count: count)
                sysctlbyname(key, &data, &count, nil, 0)
                info = String(bytes: data, encoding: .utf8)
            }
            return info ?? ""
        }
        
        information += "\n\n\n\n\n"
        information += "------------------ System Information ------------------\n"
        information += "| macOS:            \(processInfo.operatingSystemVersionString)\n"
        information += "| Machine Model:    \(systemProfile("hw.model"))\n"
        information += "| CPU:              \(systemProfile("machdep.cpu.brand_string"))\n"
        information += "| Physical Memory:  \(processInfo.physicalMemory / 1024 / 1024) MB\n"
        information += "| Application Path: \(Bundle.main.bundlePath)\n"
        information += "--------------------------------------------------------\n"
        
        return information
    }
    
    static func launchEmailApplication() {
        // Closure for copying email address to general pasteboard.
        let copyEmailAddress = {
            let pasteboard = NSPasteboard.general()
            pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
            pasteboard.setString(Constants.emailRecipient, forType: NSPasteboardTypeString)
            
            NSUserNotificationCenter.default.deliverNotification(with: "Email Address Copied",
                                                                 informativeText: Constants.emailRecipient)
        }
        
        NSAlert.alert(messageText: "Do you want to launch email application?",
                      informativeText: "You can also just copy author's email address.",
                      buttonTitles: ["Launch", "Copy", "Cancel"]) { response in
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
                            if !done {
                                NSAlert.alert(messageText: "Failed to launch email application. Copy Author's email address?",
                                              informativeText: "Please launch email application yourself.",
                                              buttonTitles: ["Copy", "Cancel"]) { response in
                                                if response == NSAlertFirstButtonReturn {   // Copy
                                                    copyEmailAddress()
                                                }
                                }
                            }
                        } else if response == NSAlertSecondButtonReturn {   // Copy
                            copyEmailAddress()
                        }
        }
    }
}
