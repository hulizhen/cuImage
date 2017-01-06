//
//  QiniuHostInfoViewController.swift
//  cuImage
//
//  Created by HuLizhen on 06/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class QiniuHostInfoViewController: NSViewController, HostsPreferencesSavable {
    @IBOutlet weak var accessKeyTextField: NSTextField!
    @IBOutlet weak var secretKeyTextField: NSTextField!
    @IBOutlet weak var domainTextField: NSTextField!
    @IBOutlet weak var bucketTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHostPreferences()
    }
    
    func saveHostPreferences() {
        preferences[.qiniuHostInfo] = QiniuHostInfo(accessKey: accessKeyTextField.stringValue,
                                                    secretKey: secretKeyTextField.stringValue,
                                                    domain: domainTextField.stringValue,
                                                    bucket: bucketTextField.stringValue).dictionary()
    }
    
    private func loadHostPreferences() {
        let qiniuHostInfo = QiniuHostInfo(dictionary: preferences[.qiniuHostInfo])
        
        accessKeyTextField.stringValue = qiniuHostInfo.accessKey
        secretKeyTextField.stringValue = qiniuHostInfo.secretKey
        domainTextField.stringValue = qiniuHostInfo.domain
        bucketTextField.stringValue = qiniuHostInfo.bucket
    }
}
