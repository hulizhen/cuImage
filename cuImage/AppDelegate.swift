//
//  AppDelegate.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import iRate
import Fabric
import Crashlytics

// MARK: - AppDelegate
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItemController = StatusItemController.shared
    let uploadManager = UploadManager.shared
    let coreDataController = CoreDataController.shared
    
    override class func initialize() -> Void {
        // Configure for iRate.
        let rate = iRate.sharedInstance()!
        rate.daysUntilPrompt = 1
        rate.eventsUntilPrompt = 20
        rate.usesUntilPrompt = 10
        rate.onlyPromptIfLatestVersion = true
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addObservers()
        NSUserNotificationCenter.default.delegate = self
        
        // Register services.
        NSApp.servicesProvider = ServicesProvider()
        
        // Register value transformers.
        let transformer = IntegerToStringTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: transformer.name)
        
        // Configure Crashlytics.
        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true])
        Fabric.with([Crashlytics.self])
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        // Ask whether the windows can be closed, in case there is unsaved changes.
        for window in NSApp.windows {
            if window.isMember(of: NSWindow.self),
                let windowShouldClose = window.delegate?.windowShouldClose {
                if !windowShouldClose(self) {
                    return .terminateLater
                }
            }
        }
        return .terminateNow
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        coreDataController.save()
        removeObservers()
    }
}

// MARK: - Observers
extension AppDelegate {
    fileprivate func addObservers() {
        let defaults = UserDefaults.standard
        defaults.addObserver(self, forKeyPath: PreferenceKeys.launchAtLogin.rawValue,
                             options: [.initial, .new], context: nil)
        defaults.addObserver(self, forKeyPath: PreferenceKeys.keepWindowsOnTop.rawValue,
                             options: [.initial, .new], context: nil)
    }
    
    fileprivate func removeObservers() {
        let defaults = UserDefaults.standard
        defaults.removeObserver(self, forKeyPath: PreferenceKeys.launchAtLogin.rawValue)
        defaults.removeObserver(self, forKeyPath: PreferenceKeys.keepWindowsOnTop.rawValue)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let key = PreferenceKeys(rawValue: keyPath) else { return }
        
        switch key {
        case PreferenceKeys.launchAtLogin:
            launchAtLogin(preferences[.launchAtLogin])
        case PreferenceKeys.keepWindowsOnTop:
            keepWindowsOnTop(preferences[.keepWindowsOnTop])
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - NSUserNotificationCenterDelegate
extension AppDelegate: NSUserNotificationCenterDelegate {
    // Deliver the notification even if the application is already frontmost.
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
