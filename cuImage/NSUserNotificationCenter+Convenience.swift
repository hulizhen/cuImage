//
//  NSUserNotificationCenter+Convenience.swift
//  cuImage
//
//  Created by HuLizhen on 12/01/2017.
//  Copyright © 2017 HuLizhen. All rights reserved.
//

import Cocoa

extension NSUserNotificationCenter {
    func deliverNotification(withTitle title: String, subtitle: String, text: String,
                                 soundName: String = NSUserNotificationDefaultSoundName) {
        let notification = NSUserNotification()        
        notification.title = title
        notification.subtitle = subtitle
        notification.informativeText = text
        notification.soundName = soundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}
