//
//  LocalizedStrings.swift
//  cuImage
//
//  Created by HuLizhen on 01/02/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation

struct LocalizedStrings {
    static let uploadResult = NSLocalizedString("Images uploaded: %d succeeded, %d failed.", comment: "")
    static let version = NSLocalizedString("Version", comment: "")
    static let acknowledgment = NSLocalizedString("Acknowledgment", comment: "")
    static let specialThanks = NSLocalizedString("Special thanks to these awesome third-party libraries:", comment: "")
    static let applicationDescription = NSLocalizedString("A handy utility to upload images to remote host, then write markdown-style URLs onto your pasteboard automatically.", comment: "")
    static let systemInformation = NSLocalizedString("System Information", comment: "")
    static let clearHistory = NSLocalizedString("Clear History", comment: "")
    
    static let urlOfUploadedImageCopied = NSLocalizedString("Uploaded image's URL copied.", comment: "")
    static let urlOfSelectedImageCopied = NSLocalizedString("Selected image's URL copied.", comment: "")

    static let saveChangesAlertMessageText = NSLocalizedString("Do you want to save the changes?", comment: "")
    static let saveChangesAlertInformativeText = NSLocalizedString("The changes will be lost if you don't save them!", comment: "")
    
    static let copyEmailAddressNotificationTitle = NSLocalizedString("Email Address Copied", comment: "")
    
    static let launchEmailApplicationAlertMessageText = NSLocalizedString("Do you want to launch email application?", comment: "")
    static let launchEmailApplicationAlertInformativeText = NSLocalizedString("You can also just copy author's email address.", comment: "")
    
    static let copyEmailAddressAlertMessageText = NSLocalizedString("Failed to launch email application. Copy Author's email address?", comment: "")
    static let copyEmailAddressAlertInformativeText = NSLocalizedString("Please launch email application yourself.", comment: "")
    
    static let noImagesToUploadAlertMessageText = NSLocalizedString("No images to upload.", comment: "")
    static let noImagesToUploadAlertInformativeText = NSLocalizedString("Before uploading, you should take a screenshort, copy images or drag images to cuImage icon on status bar.", comment: "")
    
    static let uploadingAlertMessageText = NSLocalizedString("Previous uploads have not finished yet, try it later.", comment: "")
    
    static let configureHostInfoAlertMessageText = NSLocalizedString("Wrong host information. Do you want to configure your host now?", comment: "")
    static let configureHostInfoAlertInformativeText = NSLocalizedString("You should get your host configured correctly before uploading images.", comment: "")
    
    static let validateButtonToolTip = NSLocalizedString("Press ⌘D to Validate.", comment: "")
    static let saveButtonToolTip = NSLocalizedString("Press ↩ to Validate.", comment: "")
    static let hostsPopUpButtonToolTip = NSLocalizedString("Currently support Qiniu host only. Wait a moment, please :)", comment: "")
    
    static let validating = NSLocalizedString("Validating...", comment: "")
    static let validation = NSLocalizedString("Validation ", comment: "")
    
    static let succeeded = NSLocalizedString("Succeeded", comment: "")
    static let failed = NSLocalizedString("Failed", comment: "")
    
    static let configure = NSLocalizedString("Configure", comment: "")
    static let save = NSLocalizedString("Save", comment: "")
    static let cancel = NSLocalizedString("Cancel", comment: "")
    static let discard = NSLocalizedString("Discard", comment: "")
    static let launch = NSLocalizedString("Launch", comment: "")
    static let copy = NSLocalizedString("Copy", comment: "")
}
