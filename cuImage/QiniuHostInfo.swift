//
//  QiniuHostInfo.swift
//  cuImage
//
//  Created by Lizhen Hu on 05/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

final class QiniuHostInfo: HostInfo {
    var name = ""
    var accessKey = ""
    var secretKey = ""
    var bucket = ""
    var domain = ""
    
    convenience init(name: String = "Qiniu", accessKey: String, secretKey: String, bucket: String, domain: String) {
        self.init()
        
        self.name = name
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.bucket = bucket
        self.domain = domain
    }
}
