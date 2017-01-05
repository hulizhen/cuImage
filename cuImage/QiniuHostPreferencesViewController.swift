//
//  QiniuHostPreferencesViewController.swift
//  cuImage
//
//  Created by HuLizhen on 04/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

class QiniuHostPreferencesViewController: NSViewController, HostsPreferencesSavable {
    @IBOutlet weak var accessKeyTextField: NSTextField!
    @IBOutlet weak var secretKeyTextField: NSTextField!
    @IBOutlet weak var domainTextField: NSTextField!
    @IBOutlet weak var bucketTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHostPreferences()
    }
    
    func saveHostPreferences() {
        let qiniuHostPreferences = QiniuHostPreferences(withAccessKey: accessKeyTextField.stringValue,
                                                        secretKey: secretKeyTextField.stringValue,
                                                        domain: domainTextField.stringValue,
                                                        bucket: bucketTextField.stringValue)

        PreferenceManager.shared.hostsPreferences.qiniuHost = qiniuHostPreferences
    }
    
    private func loadHostPreferences() {
        let qiniuHostPreferences = PreferenceManager.shared.hostsPreferences.qiniuHost
        
        accessKeyTextField.stringValue = qiniuHostPreferences.accessKey
        secretKeyTextField.stringValue = qiniuHostPreferences.secretKey
        domainTextField.stringValue = qiniuHostPreferences.domain
        bucketTextField.stringValue = qiniuHostPreferences.bucket
    }
}
