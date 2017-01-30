//
//  NSAttributedString+Hyperlink.swift
//  cuImage
//
//  Created by HuLizhen on 30/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension NSAttributedString {
    static func hyperlink(from string: String, with url: URL) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attributedString.length)
        
        attributedString.beginEditing()
        
        // Attach link.
        attributedString.addAttribute(NSLinkAttributeName,
                                      value: url.absoluteString,
                                      range: range)
        
        // Make the text appear in blue.
        attributedString.addAttribute(NSForegroundColorAttributeName,
                                      value: NSColor.blue,
                                      range: range)
        
        // Make the text appear with an underline.
        attributedString.addAttribute(NSUnderlineStyleAttributeName,
                                      value: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue),
                                      range: range)
        
        attributedString.endEditing()
        
        return attributedString
    }
}
