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
    
    static func setPasteboard(_ pasteboard: NSPasteboard = NSPasteboard.general(), with urlString: String) {
        pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
        pasteboard.setString(urlString, forType: NSPasteboardTypeString)
        
        NSUserNotificationCenter.default.deliverNotification(withTitle: "Image Uploaded",
                                                             subtitle: "URL has been copied to pasteboard",
                                                             text: urlString)
    }
}
