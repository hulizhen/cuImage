//
//  StatusItemController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import MASShortcut

final class StatusItemController: NSObject {
    static let shared = StatusItemController()
    
    let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var uploadImageMenuItem: NSMenuItem!
    @IBOutlet weak var preferencesMenuItem: NSMenuItem!
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    
    lazy var aboutWindowController: AboutWindowController = AboutWindowController()
    lazy var preferencesWindowController: PreferencesWindowController = PreferencesWindowController()
    
    private override init() {
        super.init()
        
        setUp()
        addObservers()
    }
    
    private func setUp() {
        guard let nibName = self.className.components(separatedBy: ".").last,
            let nib = NSNib(nibNamed: nibName, bundle: nil),
            nib.instantiate(withOwner: self, topLevelObjects: nil) else {
                fatalError("Failed to instantiate \(self.className)")
        }
        
        statusItem.title = Bundle.main.infoDictionary![kIOBundleNameKey] as? String
        statusItem.toolTip = Bundle.main.infoDictionary![kIOBundleNameKey] as? String
        statusItem.menu = menu
    }

    @IBAction func handleTappedMenuItem(_ item: NSMenuItem) {
        switch item {
        case uploadImageMenuItem:
            UploadController.shared.uploadImageOnPasteboard()
        case preferencesMenuItem:
            preferencesWindowController.showWindow(item)
            NSApp.activate(ignoringOtherApps: true)
        case aboutMenuItem:
            aboutWindowController.showWindow(item)
            NSApp.activate(ignoringOtherApps: true)
        default:
            break
        }
    }
    
    private func addObservers() {
        let defaults = UserDefaults.standard
        
        defaults.addObserver(self, forKeyPath: PreferenceKeys.uploadImageShortcut.rawValue,
                             options: [.initial, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        guard let key = PreferenceKeys(rawValue: keyPath) else { return }
        
        switch key {
        case PreferenceKeys.uploadImageShortcut:
            uploadImageMenuItem.setKeyEquivalent(withShortcut: preferences[.uploadImageShortcut])
        default:
            print("Observe value for key path: \(keyPath).")
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
