//
//  StatusItemController.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import MASShortcut
import CoreData

enum StatusItemStatus {
    case idle
    case uploading(Float, Int, Int)  // (upload percent, uploaded items, total items)
}

final class StatusItemController: NSObject {
    static let shared = StatusItemController()
    private let coreDataController = CoreDataController.shared
    private let aboutWindowController = AboutWindowController.shared
    private let preferencesWindowController = PreferencesWindowController.shared
    
    let statusItem: NSStatusItem
    let statusItemView: StatusItemView

    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var uploadImageMenuItem: NSMenuItem!
    @IBOutlet weak var uploadHistoryMenu: NSMenu!
    @IBOutlet weak var preferencesMenuItem: NSMenuItem!
    @IBOutlet weak var feedbackMenuItem: NSMenuItem!
    @IBOutlet weak var aboutMenuItem: NSMenuItem!
    var clearHistoryMenuItem: NSMenuItem!
    var uploadHistoryMenuItems = [NSMenuItem]()
    
    deinit {
        removeObservers()
        NSStatusBar.system.removeStatusItem(statusItem)
    }
    
    private override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItemView = StatusItemView(frame: statusItem.button!.frame)
        super.init()
        
        setUp()
        addObservers()
    }
    
    private func setUp() {
        guard let nibName = className.components(separatedBy: ".").last,
            let nib = NSNib(nibNamed: nibName, bundle: nil),
            nib.instantiate(withOwner: self, topLevelObjects: nil) else {
                assert(false, "Failed to instantiate \(self.className)")
                return
        }

        statusItem.button!.addSubview(statusItemView)
        statusItem.menu = menu
        updateStatusItemStatus(.idle)
        
        uploadHistoryMenu.autoenablesItems = false
        
        // Insert 'Clear History' and separator menu items to upload history submenu.
        clearHistoryMenuItem = NSMenuItem(title: LocalizedStrings.clearHistory,
                                          action: #selector(clearUploadHistory(_:)),
                                          keyEquivalent: "")
        clearHistoryMenuItem.target = self
        uploadHistoryMenuItems.append(clearHistoryMenuItem)
        uploadHistoryMenuItems.append(NSMenuItem.separator())
        
        makeUploadHistoryMenu()
    }

    @IBAction func handleTappedMenuItem(_ item: NSMenuItem) {
        switch item {
        case uploadImageMenuItem:
            UploadManager.shared.uploadImagesOnPasteboard()
        case clearHistoryMenuItem:
            clearUploadHistory(item)
        case preferencesMenuItem:
            preferencesWindowController.showWindow(item)
        case feedbackMenuItem:
            DispatchQueue.main.async {
                launchEmailApplication()
            }
        case aboutMenuItem:
            aboutWindowController.showWindow(item)
        default:
            break
        }
    }
    
    @objc
    func clearUploadHistory(_ sender: NSMenuItem) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UploadedItem")
        
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let _ = try? coreDataController.persistentStoreCoordinator.execute(deleteRequest,
                                                                               with: coreDataController.managedObjectContext)
    
        makeUploadHistoryMenu(with: [])
    }
    
    private func makeUploadHistoryMenu(with uploadedItems: [UploadedItem], reset: Bool = true) {
        if reset {
            uploadHistoryMenu.removeAllItems()
            for item in uploadHistoryMenuItems {
                uploadHistoryMenu.addItem(item)
            }
        }
        
        // Populate menu with uploaded items.
        for uploadedItem in uploadedItems {
            if let data = uploadedItem.thumbnail as Data?,
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
                uploadHistoryMenu.insertItem(item, at: uploadHistoryMenuItems.count)
            }
        }
        
        clearHistoryMenuItem.isEnabled = uploadHistoryMenu.numberOfItems > uploadHistoryMenuItems.count
    }
    
    private func makeUploadHistoryMenu() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UploadedItem")
        
        if let items = (try? coreDataController.managedObjectContext.fetch(fetchRequest)) as? [UploadedItem] {
            makeUploadHistoryMenu(with: items)
        }
    }
    
    @objc
    func managedObjectContextObjectsDidChange(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            if let uploadedItems = Array(inserts) as? [UploadedItem] {
                makeUploadHistoryMenu(with: uploadedItems, reset: false)
            }
        }
        
        clearHistoryMenuItem.isEnabled = uploadHistoryMenu.numberOfItems > uploadHistoryMenuItems.count
    }
    
    @objc
    func handleUploadedItemMenuItem(_ item: NSMenuItem) {
        guard let uploadedItem = item.representedObject as? UploadedItem else { return }
        
        if let urlString = uploadedItem.urlString {
            NSPasteboard.general.addURLStrings([urlString], markdown: preferences[.useMarkdownURL])
            NSUserNotificationCenter.default.deliverNotification(with: LocalizedStrings.urlOfSelectedImageCopied)
        }
    }
    
    // Update status item view and tool tip.
    func updateStatusItemStatus(_ status: StatusItemStatus) {
        let infoDictionary = Bundle.main.infoDictionary!
        let applicationName = infoDictionary[Constants.applicationName] as! String

        switch status {
        case .idle:
            DispatchQueue.main.async {
                self.statusItemView.updateImage(.appIcon)
                
                let shortVersion = infoDictionary[Constants.shortVersion] as! String
                self.statusItem.toolTip = applicationName + " " + shortVersion
            }
        case let .uploading(uploadPercent, uploadedItems, totalItems):
            DispatchQueue.main.async {
                self.statusItemView.updateImage(.uploadProgress(uploadPercent))
                
                let percent = String(format: "%.2f", uploadPercent * 100)
                self.statusItem.toolTip = applicationName + " is uploading: \(percent)% [\(uploadedItems)/\(totalItems)]"
            }
        }
    }
}

// MARK: - Observers
extension StatusItemController {
    fileprivate func addObservers() {
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
}
