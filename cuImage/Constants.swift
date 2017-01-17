//
//  Constants.swift
//  cuImage
//
//  Created by HuLizhen on 10/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Foundation

struct Constants {
    // Assets
    static let appIcon = "AppIcon"
    static let statusItemIcon = "StatusItemIcon"
    static let draggingDestinationBox = "DraggingDestinationBox"
    static let validIndicator = "ValidIndicator"
    static let invalidIndicator = "InvalidIndicator"
    static let generalPreferences = "GeneralPreferences"
    static let shortcutsPreferences = "ShortcutsPreferences"
    static let hostsPreferences = "HostPreferences"
    static let uploadingProgress = "UploadingProgress"

    static let uploadingProgressCount = 13  // 0 ... 12
    
    // Used for validating host informations.
    static let testString = "Hello"
    
    // Keys in Info.plist.
    static let applicationName = kCFBundleNameKey as String
    static let mainBundleIdentifier = kCFBundleIdentifierKey as String
    static let launcherBundleIdentifier = "LauncherBundleIdentifier"
    static let humanReadableCopyright = "NSHumanReadableCopyright"
    
    // Email information for feedback.
    static let emailRecipient = "ihulizhen@foxmail.com"
    static let emailSubject = "[cuImage]"
    static let emailBody = "Thanks for the feedback. Any detail would be helpful :)"
    
    // Random crypto string in hex format for cryptor.
    // This hould not been changed, otherwise the data
    // encrypted previously will not be decrypted correctly.
    static let cryptoKey = String(bytes: [0x55, 0x63, 0x3A, 0x54,
                                          0x53, 0x6E, 0x67, 0x57,
                                          0x6E, 0x6F, 0x38, 0x24,
                                          0x4F, 0x33, 0x4F, 0x64], encoding: .utf8)!
    
    // Misc
    static let notificationPreferencesPane = "/System/Library/PreferencePanes/Notifications.prefPane"
}
