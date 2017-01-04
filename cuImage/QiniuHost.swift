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
    
    let qiniuHostPreferences = PreferenceManager.shared.hostsPreferences.qiniuHost
    
    private override init() {
        super.init()
    }
    
    convenience init(WithDelegate delegate: HostDelegate?) {
        self.init()
        
        self.delegate = delegate
        
        makeToken(withAccessKey: qiniuHostPreferences.accessKey,
                  secretKey: qiniuHostPreferences.secretKey,
                  scope: qiniuHostPreferences.bucket)
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

extension QiniuHost: Host {
    func uploadImage(_ image: NSImage, named name: String, in type: NSBitmapImageFileType) {
        guard let _ = token else {
            assert(false, "Make the upload token first.")
        }
        
        let bitmap = NSBitmapImageRep(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        let data = bitmap.representation(using: type, properties: [:])
        let option = QNUploadOption(mime: nil, progressHandler: progressHandler, params: nil, checkCrc: false, cancellationSignal: nil)
        
        // Image file name.
        let key = name + "_" + Date.simpleFormatter.string(from: Date()) + "." + type.string
        
        // Upload image.
        uploadManager.put(data, key: key, token: token, complete: { (info, key, response) in
            print(info!, key!)
            
            if info!.isOK {
                let urlString = "![](http://" + self.qiniuHostPreferences.domain + "/" + key! + ")"
                self.delegate?.host(self, didUploadImageWithURLString: urlString)
            } else {
                assert(false, "Failed to upload image")
            }
        }, option: option)
    }
    
    private func progressHandler(key: String?, percent: Float) {
        delegate?.host(self, isUploadingImageWithPercent: percent)
    }
}

