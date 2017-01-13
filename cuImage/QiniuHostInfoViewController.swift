//
//  QiniuHostInfoViewController.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class QiniuHostInfoViewController: NSViewController, HostInfoViewController {
    @IBOutlet weak var accessKeyTextField: NSTextField!
    @IBOutlet weak var secretKeyTextField: NSTextField!
    @IBOutlet weak var bucketTextField: NSTextField!
    @IBOutlet weak var domainTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHostInfo()
    }
    
    func validateHostInfo(completion: @escaping (Bool) -> ()) {
        let qiniuHostInfo = QiniuHostInfo(accessKey: accessKeyTextField.stringValue,
                                          secretKey: secretKeyTextField.stringValue,
                                          bucket: bucketTextField.stringValue,
                                          domain: domainTextField.stringValue)
        QiniuHost().validateHostInfo(qiniuHostInfo, completion: completion)
    }
    
    func saveHostInfo() {
        preferences[.qiniuHostInfo] = QiniuHostInfo(accessKey: accessKeyTextField.stringValue,
                                                    secretKey: secretKeyTextField.stringValue,
                                                    bucket: bucketTextField.stringValue,
                                                    domain: domainTextField.stringValue)
    }
    
    private func loadHostInfo() {
        if let qiniuHostInfo = preferences[.qiniuHostInfo] as? QiniuHostInfo {
            accessKeyTextField.stringValue = qiniuHostInfo.accessKey
            secretKeyTextField.stringValue = qiniuHostInfo.secretKey
            bucketTextField.stringValue = qiniuHostInfo.bucket
            domainTextField.stringValue = qiniuHostInfo.domain
        }
    }
}
