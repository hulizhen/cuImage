//
//  QiniuHost.swift
//  cuImage
//
//  Created by Lizhen Hu on 03/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa
import Qiniu
import HappyDNS

final class QiniuHost: NSObject {
    weak var delegate: HostDelegate?
    fileprivate var uploadManager: QNUploadManager!
    fileprivate var qiniuHostInfo: QiniuHostInfo?
    private let tokenValidityDuration = TimeInterval(integerLiteral: 24 * 3600)
    
    deinit {
        removeObservers()
    }
    
    override init() {
        super.init()
        addObservers()

        // Automatically recognize different regions of the storage zone.
        let configuration = QNConfiguration.build { builder in
            let dns = QNDnsManager([QNResolver.system()], networkInfo: QNNetworkInfo.normal())
            builder?.setZone(QNAutoZone(https: true, dns: dns))
        }
        uploadManager = QNUploadManager(configuration: configuration)
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
    
    fileprivate func makeToken(accessKey: String, secretKey: String, bucket: String) -> String? {
        guard accessKey != "", secretKey != "", bucket != "" else {
            return nil
        }

        // Construct upload policy.
        let deadline = UInt32(Date().timeIntervalSince1970 + tokenValidityDuration)
        let uploadPolicy: [String: Any] = ["scope": bucket, "deadline": deadline]
        
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
    
    func validateHostInfo(_ hostInfo: QiniuHostInfo, completionHandler: @escaping (Bool) -> Void) {
        guard hostInfo.accessKey != "", hostInfo.secretKey != "",
            hostInfo.bucket != "", hostInfo.domain != "" else {
                completionHandler(false)
                return
        }
        
        let testString = Constants.testString
        let token = makeToken(accessKey: hostInfo.accessKey,
                              secretKey: hostInfo.secretKey,
                              bucket: hostInfo.bucket)
        
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
            completionHandler(succeeded)
        }, option: nil)
    }
}

extension QiniuHost: Host {
    func uploadImageData(_ data: Data, named name: String) {
        let domain = Bundle.main.infoDictionary![Constants.mainBundleIdentifier] as! String
        let error = NSError(domain: domain, code: 0, userInfo: nil)

        // Make the upload token first.
        guard let hostInfo = qiniuHostInfo,
            let token = makeToken(accessKey: hostInfo.accessKey, secretKey: hostInfo.secretKey, bucket: hostInfo.bucket) else {
                NSAlert.alert(alertStyle: .critical,
                              messageText: LocalizedStrings.configureHostInfoAlertMessageText,
                              informativeText: LocalizedStrings.configureHostInfoAlertInformativeText,
                              buttonTitles: [LocalizedStrings.configure, LocalizedStrings.cancel]) { response in
                                if response == NSAlertFirstButtonReturn {   // Configure
                                    PreferencesWindowController.shared.showHostPreferencesPane()
                                }
                }
                
                delegate?.host(self, didFailToUploadImageNamed: name, error: error)
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
