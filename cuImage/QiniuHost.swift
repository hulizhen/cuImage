//
//  QiniuHost.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import Qiniu

final class QiniuHost {
    private struct Constant {
        static let accessTokenDuration: TimeInterval = 3600
    }
    
    weak var delegate: HostDelegate?
    
    fileprivate let uploadManager = QNUploadManager()!
    fileprivate var token: String!

    let qiniuHostInfo = QiniuHostInfo(dictionary: preferences[.qiniuHostInfo])
    
    init() {
        makeToken(accessKey: qiniuHostInfo.accessKey,
                  secretKey: qiniuHostInfo.secretKey,
                  scope: qiniuHostInfo.bucket)
    }
    
    convenience init(delegate: HostDelegate?) {
        self.init()
        
        self.delegate = delegate
    }
    
    private func makeToken(accessKey: String, secretKey: String, scope: String) {
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
        assert(token != nil, "Make the upload token first.")
        
        let bitmap = NSBitmapImageRep(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        let data = bitmap.representation(using: type, properties: [:])
        let option = QNUploadOption(mime: nil, progressHandler: progressHandler, params: nil, checkCrc: false, cancellationSignal: nil)
        
        // Make image file name.
        let key = name + "_" + Date.simpleFormatter.string(from: Date()) + "." + type.string
        
        // Upload image.
        uploadManager.put(data, key: key, token: token, complete: { (info, key, response) in
            print(info!, key!)
            
            if info!.isOK {
                let urlString = "![](" + self.qiniuHostInfo.domain + "/" + key! + ")"
                self.delegate?.host(self, didUploadImageWithURLString: urlString)
            } else {
                assert(false, "Failed to upload image.")
            }
        }, option: option)
    }
    
    private func progressHandler(key: String?, percent: Float) {
        delegate?.host(self, isUploadingImageWithPercent: percent)
    }
}
