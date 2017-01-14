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
    
    let statusItem: NSStatusItem
    let statusItemView: StatusItemView

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var uploadImageMenuItem: NSMenuItem!
    @IBOutlet weak var preferencesMenuItem: NSMenuItem!
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    
    lazy var aboutWindowController: AboutWindowController = AboutWindowController()
    lazy var preferencesWindowController: PreferencesWindowController = PreferencesWindowController()
    
    deinit {
        removeObservers()
        NSStatusBar.system().removeStatusItem(statusItem)
    }
    
    private override init() {
        statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
        statusItemView = StatusItemView(frame: statusItem.button!.frame)
        super.init()
        
        setUp()
        addObservers()
    }
    
    private func setUp() {
        guard let nibName = self.className.components(separatedBy: ".").last,
            let nib = NSNib(nibNamed: nibName, bundle: nil),
            nib.instantiate(withOwner: self, topLevelObjects: nil) else {
                assert(false, "Failed to instantiate \(self.className)")
        }
        
        
        statusItem.button!.addSubview(statusItemView)
        statusItem.toolTip = Bundle.main.infoDictionary![kIOBundleNameKey] as? String
        statusItem.menu = menu
    }

    @IBAction func handleTappedMenuItem(_ item: NSMenuItem) {
        switch item {
        case uploadImageMenuItem:
            UploadManager.shared.uploadImageOnPasteboard()
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
    
    fileprivate func removeObservers() {
        let defaults = UserDefaults.standard
        defaults.removeObserver(self, forKeyPath: PreferenceKeys.uploadImageShortcut.rawValue)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let key = PreferenceKeys(rawValue: keyPath) else { return }
        
        switch key {
        case PreferenceKeys.uploadImageShortcut:
            if let shortcut = preferences[.uploadImageShortcut] {
                uploadImageMenuItem.setKeyEquivalent(withShortcut: shortcut)
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
