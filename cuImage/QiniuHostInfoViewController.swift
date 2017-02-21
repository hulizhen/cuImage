//
//  QiniuHostInfoViewController.swift
//  cuImage
//
//  Created by Lizhen Hu on 06/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Cocoa

final class QiniuHostInfoViewController: BaseViewController, HostInfoViewController {
    @IBOutlet weak var accessKeyTextField: NSTextField!
    @IBOutlet weak var secretKeyTextField: NSTextField!
    @IBOutlet weak var bucketTextField: NSTextField!
    @IBOutlet weak var domainTextField: NSTextField!
    
    // The access control is awesome :)
    fileprivate(set) var isInfoChanged = false
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadHostInfo()
    }
    
    func validateHostInfo(completionHandler: @escaping (Bool) -> Void) {
        let qiniuHostInfo = QiniuHostInfo(accessKey: accessKeyTextField.stringValue,
                                          secretKey: secretKeyTextField.stringValue,
                                          bucket: bucketTextField.stringValue,
                                          domain: domainTextField.stringValue)
        QiniuHost().validateHostInfo(qiniuHostInfo, completionHandler: completionHandler)
    }
    
    func saveHostInfo() {
        isInfoChanged = false
        preferences[.qiniuHostInfo] = QiniuHostInfo(accessKey: accessKeyTextField.stringValue,
                                                    secretKey: secretKeyTextField.stringValue,
                                                    bucket: bucketTextField.stringValue,
                                                    domain: domainTextField.stringValue)
    }
    
    func discardHostInfo() {
        isInfoChanged = false
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

extension QiniuHostInfoViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        isInfoChanged = true
    }
}
