//
//  NSAttributedString+Hyperlink.swift
//  cuImage
//
//  Created by Lizhen Hu on 30/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

extension NSAttributedString {
    /// Make an attributed string with embeded hyperlink.
    static func hyperlink(from string: String, with url: URL) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attributedString.length)
        
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
        
        return attributedString
    }
    
    static func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString()
        
        result.append(lhs)
        result.append(rhs)
        return result
    }
    
    static func +=(lhs: inout NSAttributedString, rhs: NSAttributedString) {
        lhs = lhs + rhs
    }
}
