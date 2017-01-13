//
//  HostInfoViewController.swift
//  cuImage
//
//  Created by HuLizhen on 10/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

protocol HostInfoViewController: class {
    var isInfoChanged: Bool { get }
    
    func alertToSaveInfo(for window: NSWindow, completion: ((NSModalResponse) -> Void)?) -> Bool
    func validateHostInfo(completion: @escaping (Bool) -> ())
    func saveHostInfo()
    func discardHostInfo()
}

// Default implementation
extension HostInfoViewController {
    /// Show alert dialog if the info is changed.
    /// - Return: Return true if info is changed, otherwise return false.
    func alertToSaveInfo(for window: NSWindow, completion: ((NSModalResponse) -> Void)?) -> Bool {
        if (isInfoChanged) {
            let alert = NSAlert()
            alert.messageText = "Do you want to save the changes?"
            alert.informativeText = "The changes will be lost if you don't save them!"
            alert.addButton(withTitle: "Save")
            alert.addButton(withTitle: "Cancel")
            alert.addButton(withTitle: "Discard")
            alert.alertStyle = .warning
            alert.beginSheetModal(for: window, completionHandler: completion)
        }
        return isInfoChanged
    }
}
