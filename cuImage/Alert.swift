//
//  Alert.swift
//  cuImage
//
//  Created by HuLizhen on 17/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

final class Alert: NSAlert {
    override func runModal() -> NSModalResponse {
        NSApp.activate(ignoringOtherApps: true)

        return super.runModal()
    }
    
    override func beginSheetModal(for sheetWindow: NSWindow, completionHandler handler: ((NSModalResponse) -> Void)? = nil) {
        NSApp.activate(ignoringOtherApps: true)

        super.beginSheetModal(for: sheetWindow, completionHandler: handler)
        return
    }
}
