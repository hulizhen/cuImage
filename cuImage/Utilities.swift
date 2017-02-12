//
//  swift
//  cuImage
//
//  Created by Lizhen Hu on 07/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import ServiceManagement

func launchAtLogin(_ launch: Bool) {
    let launcherBundleIdentifier = Bundle.main.infoDictionary![Constants.launcherBundleIdentifier] as! String
    SMLoginItemSetEnabled(launcherBundleIdentifier as CFString, launch)
}

func keepWindowsOnTop(_ top: Bool) {
    for window in NSApp.windows {
        if window.isMember(of: NSWindow.self) {
            window.level = Int(CGWindowLevelForKey(top ? .floatingWindow : .normalWindow))
        }
    }
}

func environmentInformation() -> String {
    var information = ""
    let processInfo = ProcessInfo()
    
    // Cloure for getting system profile.
    let systemProfile = { (key: String) -> String in
        var info: String?
        var count: Int = 0
        
        sysctlbyname(key, nil, &count, nil, 0)
        if count > 0 {
            var data = [UInt8](repeating: 0, count: count - 1)  // Exclude the termination symbol '\0'.
            sysctlbyname(key, &data, &count, nil, 0)
            info = String(bytes: data, encoding: .utf8)
        }
        return info ?? ""
    }
    
    let version = processInfo.operatingSystemVersion
    let osShortVersion = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    let osBuildVersion = systemProfile("kern.osversion")
    let osVersion = "\(osShortVersion) (\(osBuildVersion))"
    
    let infoDictionary = Bundle.main.infoDictionary!
    let appShortVersion = infoDictionary[Constants.shortVersion] as! String
    let appBuildVersion = infoDictionary[Constants.buildVersion] as! String
    let appVersion = "\(appShortVersion) (\(appBuildVersion))"
    
    information += "\n\n\n\n\n"
    information += "------------------ " + LocalizedStrings.environmentInformation + " ------------------\n"
    information += "| macOS: Version \(osVersion)\n"
    information += "| Machine Model: \(systemProfile("hw.model"))\n"
    information += "| CPU: \(systemProfile("machdep.cpu.brand_string"))\n"
    information += "| Physical Memory: \(processInfo.physicalMemory / 1024 / 1024) MB\n"
    information += "| Application Version: \(appVersion)\n"
    information += "| Application Path: \(Bundle.main.bundlePath)\n"
    information += "--------------------------------------------------------\n"
    
    return information
}

func launchEmailApplication() {
    // Closure for copying email address to general pasteboard.
    let copyEmailAddress = {
        let pasteboard = NSPasteboard.general()
        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setString(Constants.emailRecipient, forType: NSPasteboardTypeString)
        
        NSUserNotificationCenter.default.deliverNotification(with: LocalizedStrings.copyEmailAddressNotificationTitle,
                                                             informativeText: Constants.emailRecipient)
    }
    
    NSAlert.alert(messageText: LocalizedStrings.launchEmailApplicationAlertMessageText,
                  informativeText: LocalizedStrings.launchEmailApplicationAlertInformativeText,
                  buttonTitles: [LocalizedStrings.launch,
                                 LocalizedStrings.copy,
                                 LocalizedStrings.cancel]) { response in
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
                            NSAlert.alert(messageText: LocalizedStrings.copyEmailAddressAlertMessageText,
                                          informativeText: LocalizedStrings.copyEmailAddressAlertInformativeText,
                                          buttonTitles: [LocalizedStrings.copy, LocalizedStrings.cancel]) { response in
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
