//
//  HostInfoViewController.swift
//  cuImage
//
//  Created by Lizhen Hu on 10/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

protocol HostInfoViewController: class {
    var isInfoChanged: Bool { get }
    
    func alertToSaveInfo(for window: NSWindow, completionHandler: ((NSApplication.ModalResponse) -> Void)?) -> Bool
    func validateHostInfo(completionHandler: @escaping (Bool) -> Void)
    func saveHostInfo()
    func discardHostInfo()
}

// Default implementation
extension HostInfoViewController {
    /// Show alert dialog if the info is changed.
    ///
    /// - Parameters:
    ///   - window: The window on which to display the sheet.
    ///   - completionHandler: The completionHandler handler that gets called when the sheet’s modal session ends.
    /// - Returns: Return true if info is changed, otherwise return false.
    func alertToSaveInfo(for window: NSWindow, completionHandler: ((NSApplication.ModalResponse) -> Void)?) -> Bool {
        if (isInfoChanged) {
            NSAlert.alert(for: window, messageText: LocalizedStrings.saveChangesAlertMessageText,
                          informativeText: LocalizedStrings.saveChangesAlertInformativeText,
                          buttonTitles: [LocalizedStrings.save,
                                         LocalizedStrings.cancel,
                                         LocalizedStrings.discard],
                          completionHandler: completionHandler)
        }
        return isInfoChanged
    }
}
