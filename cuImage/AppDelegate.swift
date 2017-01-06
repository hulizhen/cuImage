//
//  AppDelegate.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItemController = StatusItemController.shared
    let uploadController = UploadController.shared
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        addObservers()
    }
}

// Observers
extension AppDelegate {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == PreferenceKeys.keepWindowsOnTop.rawValue {
            if let top = change?[.newKey] as? Bool {
                keepWindowsOnTop(top)
            }
        }
    }
    
    fileprivate func addObservers() {
        let defaults = UserDefaults.standard
        
        defaults.addObserver(self, forKeyPath: PreferenceKeys.keepWindowsOnTop.rawValue,
                             options: [.initial, .new], context: nil)
    }
}
