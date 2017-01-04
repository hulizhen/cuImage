//
//  QiniuHostPreferences.swift
//  cuImage
//
//  Created by HuLizhen on 04/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class QiniuHostPreferences: NSObject, NSCoding {
    var accessKey: String
    var secretKey: String
    var domain: String
    var bucket: String
    
    convenience override init() {
        self.init(withAccessKey: "", secretKey: "", domain: "", bucket: "")
    }
    
    init(withAccessKey accessKey: String, secretKey: String, domain: String, bucket: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.domain = domain
        self.bucket = bucket
        
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(accessKey, forKey: #keyPath(accessKey))
        aCoder.encode(secretKey, forKey: #keyPath(secretKey))
        aCoder.encode(domain, forKey: #keyPath(domain))
        aCoder.encode(bucket, forKey: #keyPath(bucket))
    }
    
    required init?(coder aDecoder: NSCoder) {
        accessKey = aDecoder.decodeObject(forKey: #keyPath(accessKey)) as! String
        secretKey = aDecoder.decodeObject(forKey: #keyPath(secretKey)) as! String
        domain = aDecoder.decodeObject(forKey: #keyPath(domain)) as! String
        bucket = aDecoder.decodeObject(forKey: #keyPath(bucket)) as! String
    }
}
