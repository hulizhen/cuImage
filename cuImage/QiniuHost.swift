//
//  QiniuHost.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import Qiniu

class QiniuHost: NSObject {
    private struct Constant {
        static let accessTokenDuration: TimeInterval = 3600
    }
    
    weak var delegate: HostDelegate?
    
    fileprivate let uploadManager = QNUploadManager()!
    fileprivate var token: String!
    
    private override init() {
        super.init()
    }
    
    convenience init(WithDelegate delegate: HostDelegate?) {
        self.init()
        
        self.delegate = delegate
    }
    
    private func makeToken(withAccessKey accessKey: String, secretKey: String, scope: String) {
        // Construct upload policy.
        let deadline = UInt32(Date().timeIntervalSince1970 + Constant.accessTokenDuration)
        let uploadPolicy: [String: Any] = ["scope": scope, "deadline": deadline]
        
        // Convert the policy to JSON data.
        let jsonData = try! JSONSerialization.data(withJSONObject: uploadPolicy, options: .prettyPrinted)
        
        // Encode the policy with URL safe base64.
        let encodedPolicy = jsonData.urlSafeBase64EncodedString()
        
        // Generate and encode HMAC-SHA1 sign of the encoded policy with the secret key.
        let encodedSign = encodedPolicy.hmac(algorithm: .sha1, key: secretKey)
        
        // Make upload token by concatenating accessKey, encodedSign and encodedPolicy.
        token = accessKey + ":" + encodedSign + ":" + encodedPolicy
    }
}

