//
//  StatusItemController.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import MASShortcut
import CoreData

final class StatusItemController: NSObject {
    static let shared = StatusItemController()
    private let managedObjectContext = CoreDataController.shared.managedObjectContext
    
    let statusItem: NSStatusItem
    let statusItemView: StatusItemView

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var uploadImageMenuItem: NSMenuItem!
    @IBOutlet weak var uploadHistoryMenu: NSMenu!
    @IBOutlet weak var preferencesMenuItem: NSMenuItem!
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    @IBOutlet weak var clearHistoryMenuItem: NSMenuItem!

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
        
        makeUploadHistoryMenu()
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(managedObjectContextObjectsDidChange(notification:)),
                                       name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
                                       object: nil)
    }
    
    fileprivate func removeObservers() {
        let defaults = UserDefaults.standard
        defaults.removeObserver(self, forKeyPath: PreferenceKeys.uploadImageShortcut.rawValue)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
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
    
    func makeUploadHistoryMenu(with uploadedItems: [UploadedItem]) {
        for uploadedItem in uploadedItems {
            if let data = uploadedItem.thumbnail as? Data,
                let thumbnail = NSImage(data: data) {
                let item = NSMenuItem()
                item.title = ""
                item.target = self
                item.action = #selector(handleUploadedItemMenuItem(_:))
                item.keyEquivalentModifierMask = []
                item.image = thumbnail
                item.toolTip = uploadedItem.urlString
                item.representedObject = uploadedItem
                
                // Skip the 'Clear History' and separator menu item.
                uploadHistoryMenu.insertItem(item, at: 2)
            }
        }
    }
    
    func makeUploadHistoryMenu() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UploadedItem")
        
        if let items = (try? managedObjectContext.fetch(fetchRequest)) as? [UploadedItem] {
            makeUploadHistoryMenu(with: items)
        }
    }
    
    func managedObjectContextObjectsDidChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            if let uploadedItems = Array(inserts) as? [UploadedItem] {
                makeUploadHistoryMenu(with: uploadedItems)
            }
        }
    }
    
    func handleUploadedItemMenuItem(_ item: NSMenuItem) {
        guard let uploadedItem = item.representedObject as? UploadedItem else { return }
        
        if let urlString = uploadedItem.urlString {
            let markdownURL = "![](" + urlString + ")"
            Utilities.setPasteboard(with: markdownURL)
        }
    }
}
