//
//  QiniuHostInfo.swift
//  cuImage
//
//  Created by HuLizhen on 05/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

final class QiniuHostInfo: NSObject, Dictionariable {
    var accessKey = ""
    var secretKey = ""
    var domain = ""
    var bucket = ""
    
    override init() { }
    
    init(accessKey: String, secretKey: String, domain: String, bucket: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.domain = domain
        self.bucket = bucket
    }
}
