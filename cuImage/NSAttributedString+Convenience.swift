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
    ///
    /// - Parameters:
    ///   - string: The string is about to be embeded a hyperlink.
    ///   - url: The URL used to be embeded.
    /// - Returns: An atrributed string appended a hyperlink.
    static func hyperlink(from string: String, with url: URL) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let range = NSMakeRange(0, attributedString.length)
        
        // Attach link.
        attributedString.addAttribute(NSLinkAttributeName,
                                      value: url.absoluteString,
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
