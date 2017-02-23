//
//  Constants.swift
//  cuImage
//
//  Created by Lizhen Hu on 10/01/2017.
//  Copyright © 2017 Lizhen Hu. All rights reserved.
//

import Foundation

struct Constants {
    // Assets
    static let statusItemIcon = "StatusItemIcon"
    static let draggingDestinationBox = "DraggingDestinationBox"
    static let succeededIndicator = "SucceededIndicator"
    static let failedIndicator = "FailedIndicator"
    static let generalPreferences = "GeneralPreferences"
    static let shortcutsPreferences = "ShortcutsPreferences"
    static let hostsPreferences = "HostPreferences"
    static let uploadProgress = "UploadProgress"
    static let alertSound = "AlertSound"
    static let dropSound = "DropSound"

    static let uploadProgressImagesCount = 13  // 0 ... 12
    static let maxSizeOfthumbnail: Float = 200
    
    static let maxActiveUploadTasksValues = [1, 2, 3, 4, 5, 10, 15]
    
    // Use for generating random string.
    static let characterSet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    static let randomCharactersLength = 6
    
    // Used for validating host informations.
    static let testString = "Hello"
    
    // Keys in Info.plist.
    static let applicationName = "CFBundleName"
    static let iconFileName = "CFBundleIconFile"
    static let mainBundleIdentifier = "CFBundleIdentifier"
    static let launcherBundleIdentifier = "LauncherBundleIdentifier"
    static let shortVersion = "CFBundleShortVersionString"
    static let buildVersion = "CFBundleVersion"
    static let humanReadableCopyright = "NSHumanReadableCopyright"
    
    // Email information for feedback.
    static let emailRecipient = "ihulizhen@foxmail.com"
    static let emailSubject = "[cuImage Feedback]"
    static let emailBody = environmentInformation()
    
    // Extra information in About window.
    static let authorLink = "http://hulizhen.github.io"
    static let thirdPartyLibraries = [
        ThirdPartyLibrary(name: "MASShortcut",
                          link: "https://github.com/shpakovski/MASShortcut",
                          description: "Modern framework for managing global keyboard shortcuts compatible with Mac App Store."),
        ThirdPartyLibrary(name: "RNCryptor",
                          link: "https://github.com/RNCryptor/RNCryptor",
                          description: "CCCryptor (AES encryption) wrappers for iOS/macOS in Swift."),
        ThirdPartyLibrary(name: "Qiniu SDK",
                          link: "https://github.com/qiniu/objc-sdk",
                          description: "Qiniu Resource (Cloud) Storage Objective-C SDK for iOS/macOS"),
        ThirdPartyLibrary(name: "AFNetworking",
                          link: "https://github.com/AFNetworking/AFNetworking",
                          description: "A delightful networking framework for iOS/watchOS/tvOS/macOS."),
        ThirdPartyLibrary(name: "HappyDNS",
                          link: "https://github.com/qiniu/happy-dns-objc",
                          description: "DNS library in Objective-C."),
        ThirdPartyLibrary(name: "iRate",
                          link: "https://github.com/nicklockwood/iRate",
                          description: "A library to help you promote your iPhone and Mac App Store apps by prompting users to rate the app after using it for a few days."),
        ThirdPartyLibrary(name: "Fabric",
                          link: "https://get.fabric.io",
                          description: "A platform that helps your mobile team build better apps, understand your users, and grow your business."),
    ]
    
    // Random crypto string in hex format for cryptor.
    // This hould not been changed, otherwise the data
    // encrypted previously will not be decrypted correctly.
    static let cryptoKey = String(bytes: [0x55, 0x63, 0x3A, 0x54,
                                          0x53, 0x6E, 0x67, 0x57,
                                          0x6E, 0x6F, 0x38, 0x24,
                                          0x4F, 0x33, 0x4F, 0x64], encoding: .utf8)!
    
    // App link on Mac App Store.
    static let macAppStoreLink = "macappstore://itunes.apple.com/cn/app/cuimage-upload-images-get/id1202764942?l=en&mt=12"
    
    // Misc.
    static let notificationPreferencesPane = "/System/Library/PreferencePanes/Notifications.prefPane"
}
