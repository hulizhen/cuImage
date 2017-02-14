//
//  AppDelegate.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

// MARK: - AppDelegate
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItemController = StatusItemController.shared
    let uploadManager = UploadManager.shared
    let coreDataController = CoreDataController.shared
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addObservers()
        NSUserNotificationCenter.default.delegate = self
        
        // Register services.
        NSApp.servicesProvider = ServicesProvider()
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
}

// MARK: - NSUserNotificationCenterDelegate
extension AppDelegate: NSUserNotificationCenterDelegate {
    // Deliver the notification even if the application is already frontmost.
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}
