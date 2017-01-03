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
    let preferenceManager = PreferenceManager.shared
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }
}
