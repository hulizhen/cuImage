//
//  AppDelegate.swift
//  cuImageLauncher
//
//  Created by HuLizhen on 07/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Check whether the main application is already running.
        var isRunning = false
        let mainAppBundleIdentifier = "com.hulizhen.cuImage"
        let runningApplications = NSWorkspace.shared().runningApplications
        for app in runningApplications {
            if app.bundleIdentifier == mainAppBundleIdentifier {
                isRunning = true
                break
            }
        }
        
        if isRunning == false {
            // Get absolute path of the main application.
            let pathComponents = Bundle.main.bundlePath.components(separatedBy: "/")
            let appPath = pathComponents[0..<pathComponents.count - 4].joined(separator: "/")
            
            // Launch the main application.
            NSWorkspace.shared().launchApplication(appPath)
        }
        
        // Terminate the launch helper.
        NSApp.terminate(self)
    }
}
