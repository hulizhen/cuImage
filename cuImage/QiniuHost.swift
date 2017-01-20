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
    weak var delegate: HostDelegate?
    fileprivate let uploadManager = QNUploadManager()!
    fileprivate var qiniuHostInfo: QiniuHostInfo?
    private let tokenValidityDuration: TimeInterval = 3600
    
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
        guard let keyPath = keyPath, let key = PreferenceKeys(rawValue: keyPath) else { return }
        
        switch key {
        case PreferenceKeys.qiniuHostInfo:
            if let hostInfo = preferences[.qiniuHostInfo] as? QiniuHostInfo {
                qiniuHostInfo = hostInfo
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    fileprivate func makeToken(accessKey: String, secretKey: String, scope: String) -> String? {
        // Construct upload policy.
        let deadline = UInt32(Date().timeIntervalSince1970 + tokenValidityDuration)
        let uploadPolicy: [String: Any] = ["scope": scope, "deadline": deadline]
        
        // Convert the policy to JSON data.
        guard let jsonData = try? JSONSerialization.data(withJSONObject: uploadPolicy, options: .prettyPrinted) else {
            return nil
        }
        
        // Encode the policy with URL safe base64.
        let encodedPolicy = jsonData.urlSafeBase64EncodedString()
        
        // Generate and encode HMAC-SHA1 sign of the encoded policy with the secret key.
        let encodedSign = encodedPolicy.hmac(algorithm: .sha1, key: secretKey)
        
        // Make upload token by concatenating accessKey, encodedSign and encodedPolicy.
        return accessKey + ":" + encodedSign + ":" + encodedPolicy
    }
    
    func validateHostInfo(_ hostInfo: QiniuHostInfo, completion: @escaping (Bool) -> Void) {
        guard hostInfo.accessKey != "", hostInfo.secretKey != "",
            hostInfo.bucket != "", hostInfo.domain != "" else {
                completion(false)
                return
        }
        
        let testString = Constants.testString
        let token = makeToken(accessKey: hostInfo.accessKey,
                              secretKey: hostInfo.secretKey,
                              scope: hostInfo.bucket)
        
        // Upload test string.
        uploadManager.put(testString.data(using: .utf8), key: testString, token: token, complete: { (info, key, response) in
            guard let info = info, let key = key else { return }
            print(info, key)
            var succeeded = info.isOK
            
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
    
    fileprivate func alertToConfigureHostInfo() {
        NSAlert.alert(alertStyle: .critical,
                      messageText: "Wrong host information. Do you want to configure your host now?",
                      informativeText: "You should get your host configured correctly before uploading images.",
                      buttonTitles: ["Configure", "Cancel"]) { response in
                        if response == NSAlertFirstButtonReturn {   // Configure
                            PreferencesWindowController.shared.showHostPreferencesPane()
                        }
        }
    }
}

extension QiniuHost: Host {
    func uploadImageData(_ data: Data, named name: String) {
        // Make the upload token first.
        guard let hostInfo = qiniuHostInfo,
            let token = makeToken(accessKey: hostInfo.accessKey,
                                  secretKey: hostInfo.secretKey,
                                  scope: hostInfo.bucket) else {
                                    alertToConfigureHostInfo()
                                    return
        }
        
        let option = QNUploadOption(progressHandler: progressHandler)
        
        // Upload image data.
        uploadManager.put(data, key: name, token: token, complete: { [weak self] (info, key, response) in
            guard let sself = self else { return }
            guard let info = info, let key = key else { return }
            
            if info.isOK {
                let urlString = hostInfo.domain + "/" + key
                sself.delegate?.host(sself, didSucceedToUploadImageNamed: name, urlString: urlString)
            } else {
                print("Failed to upload: \(info), \(key)")
                let domain = Bundle.main.infoDictionary![Constants.mainBundleIdentifier] as! String
                let error = NSError(domain: domain, code: 0, userInfo: nil)
                sself.delegate?.host(sself, didFailToUploadImageNamed: name, error: error)
            }
            }, option: option)
    }
    
    private func progressHandler(key: String?, percent: Float) {
        if let name = key {
            delegate?.host(self, isUploadingImageNamed: name, percent: percent)
        }
    }
}
