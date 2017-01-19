//
//  NSPasteboard+Convenience.swift
//  cuImage
//
//  Created by HuLizhen on 19/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension NSPasteboard {
    func setURLString(_ urlString: String, inMarkdown markdown: Bool) {
        let string = markdown ? "![](" + urlString + ")" : urlString
        
        declareTypes([NSPasteboardTypeString], owner: nil)
        setString(string, forType: NSPasteboardTypeString)
    }
}
