//
//  Data+Base64.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation

extension Data {
    func urlSafeBase64EncodedString() -> String {
        var encodedString = base64EncodedString()
        encodedString = encodedString.replacingOccurrences(of: "+", with: "-")
        encodedString = encodedString.replacingOccurrences(of: "/", with: "_")
        return encodedString
    }
}
