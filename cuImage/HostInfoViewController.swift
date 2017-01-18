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
    func validateHostInfo(completion: @escaping (Bool) -> Void)
    func saveHostInfo()
    func discardHostInfo()
}

// Default implementation
extension HostInfoViewController {
    /**
     Show alert dialog if the info is changed.
     
     - parameters:
        - window: The window on which to display the sheet.
        - completion: The completion handler that gets called when the sheet’s modal session ends.
     
     - returns: Return true if info is changed, otherwise return false.
     */
    func alertToSaveInfo(for window: NSWindow, completion: ((NSModalResponse) -> Void)?) -> Bool {
        if (isInfoChanged) {
            NSAlert.alert(for: window, messageText: "Do you want to save the changes?",
                          informativeText: "The changes will be lost if you don't save them!",
                          buttonTitles: ["Save", "Cancel", "Discard"], completion: completion)
        }
        return isInfoChanged
    }
}
