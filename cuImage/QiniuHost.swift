//
//  QiniuHost.swift
//  cuImage
//
//  Created by HuLizhen on 03/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa
import Qiniu

final class QiniuHost: NSObject {
    private struct Constant {
        static let accessTokenDuration: TimeInterval = 3600
    }
    
    weak var delegate: HostDelegate?
    
    fileprivate let uploadManager = QNUploadManager()!
    fileprivate var token: String!

    var qiniuHostInfo: QiniuHostInfo!
    
    deinit {
        removeObservers()
    }
    
    override init() {
        super.init()
        addObservers()
    }
    
    convenience init(delegate: HostDelegate?) {
        self.init()
        
        self.delegate = delegate
    }
    
    private func addObservers() {
        let defaults = UserDefaults.standard
        defaults.addObserver(self, forKeyPath: PreferenceKeys.qiniuHostInfo.rawValue,
                             options: [.initial, .new], context: nil)
    }
    
    fileprivate func removeObservers() {
        let defaults = UserDefaults.standard
        defaults.removeObserver(self, forKeyPath: PreferenceKeys.qiniuHostInfo.rawValue)
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        guard let key = PreferenceKeys(rawValue: keyPath) else { return }
        
        switch key {
        case PreferenceKeys.qiniuHostInfo:
            qiniuHostInfo = QiniuHostInfo(dictionary: preferences[.qiniuHostInfo])
            
            token = makeToken(accessKey: qiniuHostInfo.accessKey,
                              secretKey: qiniuHostInfo.secretKey,
                              scope: qiniuHostInfo.bucket)
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func makeToken(accessKey: String, secretKey: String, scope: String) -> String {
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
        return accessKey + ":" + encodedSign + ":" + encodedPolicy
    }
    
    func validateHostInfo(_ hostInfo: QiniuHostInfo, completion: @escaping (Bool) -> ()) {
        let testString = Constants.testString
        let token = makeToken(accessKey: hostInfo.accessKey,
                              secretKey: hostInfo.secretKey,
                              scope: hostInfo.bucket)
        
        // Upload test string.
        uploadManager.put(testString.data(using: .utf8), key: testString, token: token,
                          complete: { (info, key, response) in
                            print(info!, key!)
                            var succeeded = info!.isOK
                            
                            // if the token is valid, then validate the domain.
                            if succeeded {
                                if let url = URL(string: hostInfo.domain + "/" + testString),
                                    let string = try? String(contentsOf: url) {
                                    succeeded = testString == string
                                } else {
                                    succeeded = false
                                }
                            }
                            completion(succeeded)
        }, option: nil)
    }
}

extension QiniuHost: Host {
    func uploadImage(_ image: NSImage, named name: String, in type: NSBitmapImageFileType) {
        assert(token != nil, "Make the upload token first.")
        
        let bitmap = NSBitmapImageRep(cgImage: image.cgImage(forProposedRect: nil, context: nil, hints: nil)!)
        let data = bitmap.representation(using: type, properties: [:])
        let option = QNUploadOption(progressHandler: progressHandler)
        
        // Make image file name.
        let key = name + "_" + Date.simpleFormatter.string(from: Date()) + "." + type.string
        
        // Upload image.
        uploadManager.put(data, key: key, token: token, complete: { [weak self] (info, key, response) in
            guard let sself = self else { return }
            print(info!, key!)
            
            if info!.isOK {
                let urlString = "![](" + sself.qiniuHostInfo.domain + "/" + key! + ")"
                sself.delegate?.host(sself, didUploadImageWithURLString: urlString)
            } else {
                assert(false, "Failed to upload image.")
            }
        }, option: option)
    }
    
    private func progressHandler(key: String?, percent: Float) {
        delegate?.host(self, isUploadingImageWithPercent: percent)
    }
}
